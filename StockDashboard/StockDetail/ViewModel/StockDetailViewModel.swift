//
//  StockDetailViewModel.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

@MainActor
class StockDetailViewModel: ObservableObject {
    
    @Published private(set) var viewState: StockDetailViewState
    
    private let symbol: String
    private let stockService: StockServiceProtocol
    private let recommendationService: StockRecommendationServiceProtocol?
    private let cache: StockDetailCacheProtocol
    private var loadDataTask: Task<Void, Never>?
    private var pollingTask: Task<Void, Never>?
    
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
        self.viewState = .initial(symbol: symbol)
        loadData()
    }
    
    func loadData() {
        
        if let cached = cache.cachedDetail(forKey: symbol) {
            updateViewStateWithResults(cached.quote, cached.profile, cached.news)
        }
        
        loadDataTask = Task {
            do {
                let now = Date()
                let calendar = Calendar.current
                let fromDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
                
                async let quoteTask = stockService.getQuote(for: symbol)
                async let profileTask = stockService.getCompanyProfile(for: symbol)
                async let newsTask = stockService.getCompanyNews(for: symbol, from: fromDate, to: now)
                
                let (quote, profile, news) = try await (quoteTask, profileTask, newsTask)
                updateViewStateWithResults(quote, profile, news)
                
                await loadRecommendationIfAvailable(quote: quote, profile: profile, news: news)
                
                cache.setCachedDetail(CachedStockDetail(
                    symbol: symbol,
                    quote: quote,
                    profile: profile,
                    news: news,
                    timestamp: Date()
                ), forKey: symbol)
                
            } catch {
                // If we already had cached data on screen, prefer to keep it
                if viewState.quote == nil && viewState.companyProfile == nil && viewState.news.isEmpty {
                    updateViewStateWithError(error.localizedDescription)
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
                    updateQuoteOnly(quote)
                } catch {
                    // For now we ignore polling errors
                }
                try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            }
        }
    }
    
    func stopPricePolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }
    
    private func loadRecommendationIfAvailable(quote: Quote, profile: CompanyProfile, news: [NewsArticle]) async {
        guard let recommendationService else { return }
        var loadingState = viewState
        loadingState.recommendationState = .loading
        viewState = loadingState
        do {
            let recommendation = try await recommendationService.recommendation(
                for: symbol,
                quote: quote,
                profile: profile,
                news: news
            )
            updateViewStateWithRecommendation(recommendation: recommendation, error: nil)
        } catch {
            updateViewStateWithRecommendation(recommendation: nil, error: error)
        }
    }
    
    private func updateViewStateWithResults(_ quote: Quote, _ profile: CompanyProfile, _ news: [NewsArticle]) {
        var newState = viewState
        newState.updateWithResults(quote, profile, news: news)
        viewState = newState
    }

    private func updateViewStateWithError(_ message: String) {
        var newState = viewState
        newState.updateWithError(message)
        viewState = newState
    }
    
    private func updateQuoteOnly(_ quote: Quote) {
        var newState = viewState
        newState.quote = quote
        viewState = newState
    }
    
    private func updateViewStateWithRecommendation(recommendation: StockRecommendation?, error: Error?) {
        var newState = viewState
        newState.recommendationState = error == nil ? .loaded(recommendation!) : .failed(error!.localizedDescription)
        viewState = newState
    }
}
