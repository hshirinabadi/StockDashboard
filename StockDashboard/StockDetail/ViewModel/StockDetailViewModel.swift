//
//  StockDetailViewModel.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

@MainActor
class StockDetailViewModel: ObservableObject {

    @Published private(set) var viewState: StockDetailViewState = .loading

    private let symbol: String
    private let stockService: StockServiceProtocol
    private let recommendationService: StockRecommendationServiceProtocol?
    private let cache: StockDetailCacheProtocol
    private var loadDataTask: Task<Void, Never>?
    private var pollingTask: Task<Void, Never>?

    private var quote: Quote?
    private var companyProfile: CompanyProfile?
    private var news: [NewsArticle] = []
    private var recommendationState: AIRecommendationState = .loading

    init(
        symbol: String,
        stockService: StockServiceProtocol = StockService(),
        cache: StockDetailCacheProtocol = InMemoryStockDetailCache.shared,
        recommendationService: StockRecommendationServiceProtocol? = OpenAIStockRecommendationService()
    ) {
        self.symbol = symbol
        self.stockService = stockService
        self.cache = cache
        self.recommendationService = recommendationService
        loadData()
    }

    func loadData() {
        if let cached = cache.cachedDetail(forKey: symbol) {
            applyResults(cached.quote, cached.profile, cached.news)
        }

        loadDataTask = Task {
            do {
                let now = Date()
                let fromDate = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? now

                async let quoteTask = stockService.getQuote(for: symbol)
                async let profileTask = stockService.getCompanyProfile(for: symbol)
                async let newsTask = stockService.getCompanyNews(for: symbol, from: fromDate, to: now)

                let (quote, profile, news) = try await (quoteTask, profileTask, newsTask)
                applyResults(quote, profile, news)

                await loadRecommendationIfAvailable(quote: quote, profile: profile, news: news)

                cache.setCachedDetail(CachedStockDetail(
                    symbol: symbol,
                    quote: quote,
                    profile: profile,
                    news: news,
                    timestamp: Date()
                ), forKey: symbol)

            } catch {
                if quote == nil && companyProfile == nil && news.isEmpty {
                    viewState = .error(error.localizedDescription)
                }
            }
        }
    }

    func startPricePolling(interval seconds: TimeInterval = 30) {
        pollingTask?.cancel()
        pollingTask = Task {
            while !Task.isCancelled {
                do {
                    let quote = try await stockService.getQuote(for: symbol)
                    self.quote = quote
                    rebuildSections()
                } catch {}
                try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            }
        }
    }

    func stopPricePolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    // MARK: - Private

    private func applyResults(_ quote: Quote, _ profile: CompanyProfile, _ news: [NewsArticle]) {
        self.quote = quote
        self.companyProfile = profile
        self.news = news
        rebuildSections()
    }

    private func loadRecommendationIfAvailable(quote: Quote, profile: CompanyProfile, news: [NewsArticle]) async {
        guard let recommendationService else { return }
        recommendationState = .loading
        rebuildSections()
        do {
            let recommendation = try await recommendationService.recommendation(
                for: symbol, quote: quote, profile: profile, news: news
            )
            recommendationState = .loaded(recommendation)
        } catch {
            recommendationState = .failed(error.localizedDescription)
        }
        rebuildSections()
    }

    private func rebuildSections() {
        var sections: [StockDetailSection] = []

        sections.append(.header(symbol: symbol, companyName: companyProfile?.name))

        if let quote {
            sections.append(.quote(
                quote: quote,
                exchange: companyProfile?.exchange,
                currency: companyProfile?.currency
            ))
        }

        sections.append(.aiRecommendation(recommendationState))

        if let profile = companyProfile {
            sections.append(.companyInfo(
                title: "Company Info",
                items: companyInfoItems(from: profile)
            ))
        }

        if let quote {
            sections.append(.keyStats(
                title: "Key Statistics",
                stats: keyStatsItems(from: quote)
            ))
        }

        if !news.isEmpty {
            sections.append(.newsHeader)
            for article in news {
                sections.append(.newsArticle(article))
            }
        }

        viewState = .loaded(sections)
    }

    private func companyInfoItems(from profile: CompanyProfile) -> [(title: String, value: String)] {
        var items: [(title: String, value: String)] = []
        if let industry = profile.finnhubIndustry { items.append(("Industry", industry)) }
        if let exchange = profile.exchange { items.append(("Exchange", exchange)) }
        if let marketCap = profile.marketCapitalization {
            items.append(("Market Cap", StockDashboardUtils.formatMarketCap(marketCap)))
        }
        items.append(("P/E Ratio", "\u{2014}"))
        return items
    }

    private func keyStatsItems(from quote: Quote) -> [(label: String, value: String)] {
        [
            ("Open", StockDashboardUtils.formatPrice(quote.open)),
            ("High", StockDashboardUtils.formatPrice(quote.high)),
            ("Low", StockDashboardUtils.formatPrice(quote.low)),
            ("Prev Close", StockDashboardUtils.formatPrice(quote.previousClose)),
        ]
    }
}
