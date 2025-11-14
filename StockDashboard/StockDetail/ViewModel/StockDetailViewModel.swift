//
//  StockDetailViewModel.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation
import Combine

@MainActor
class StockDetailViewModel {
    
    @Published private(set) var viewState: StockDetailViewState
    
    var viewStatePublisher: AnyPublisher<StockDetailViewState, Never> {
        return $viewState.eraseToAnyPublisher()
    }
    
    private let stockService: StockServiceProtocol
    private var loadDataTask: Task<Void, Never>?
    private var pollingTask: Task<Void, Never>?
    
    init(symbol: String, stockService: StockServiceProtocol = StockService()) {
        self.stockService = stockService
        self.viewState = .initial(symbol: symbol)
        viewState.sections = makeSections(from: viewState)
        loadData()
    }
    
    func loadData() {
        loadDataTask?.cancel()
        loadDataTask = Task {
            do {
                let now = Date()
                let calendar = Calendar.current
                let fromDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
                
                async let quoteTask = stockService.getQuote(for: viewState.symbol)
                async let profileTask = stockService.getCompanyProfile(for: viewState.symbol)
                async let newsTask = stockService.getCompanyNews(for: viewState.symbol, from: fromDate, to: now)
                
                let (quote, profile, news) = try await (quoteTask, profileTask, newsTask)
                updateViewStateWithResults(quote, profile, news)
                
            } catch {
                updateViewStateWithError(error.localizedDescription)
            }
        }
    }
    
    // Can configure poll interval later depending on whether the market is open/closed
    func startPricePolling(interval seconds: TimeInterval = 30) {
        pollingTask?.cancel()
        pollingTask = Task {
            while !Task.isCancelled {
                do {
                    let quote = try await stockService.getQuote(for: viewState.symbol)
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
    
    private func updateViewStateWithResults(_ quote: Quote, _ profile: CompanyProfile, _ news: [NewsArticle]) {
        var newState = viewState
        newState.updateWithResults(quote, profile, news: news)
        newState.sections = makeSections(from: newState)
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
        newState.sections = makeSections(from: newState)
        viewState = newState
    }
    
    // MARK: - Section Management
    private func makeSections(from state: StockDetailViewState) -> [StockDetailSection] {
        var sections: [StockDetailSection] = []
        
        sections.append(
            StockDetailSection(
                type: .header,
                items: [StockDetailItem(section: .header, id: "header")]
            )
        )
        
        sections.append(
            StockDetailSection(
                type: .quote,
                items: [StockDetailItem(section: .quote, id: "quote")]
            )
        )
        
        sections.append(
            StockDetailSection(
                type: .companyInfo,
                items: [StockDetailItem(section: .companyInfo, id: "companyInfo")]
            )
        )
        
        sections.append(
            StockDetailSection(
                type: .keyStats,
                items: [StockDetailItem(section: .keyStats, id: "keyStats")]
            )
        )
        
        if !state.news.isEmpty {
            var newsItems: [StockDetailItem] = [
                StockDetailItem(section: .news, id: "newsHeader")
            ]
            newsItems += state.news.map {
                StockDetailItem(section: .news, id: $0.id)
            }
            sections.append(StockDetailSection(type: .news, items: newsItems))
        }
        
        return sections
    }
}
