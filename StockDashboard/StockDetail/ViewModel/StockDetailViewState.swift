//
//  StockDetailViewState.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

enum StockDetailViewState {
    case loading
    case loaded([StockDetailSection])
    case error(String)
}

enum StockDetailSection: Identifiable {
    case header(symbol: String, companyName: String?)
    case quote(quote: Quote, exchange: String?, currency: String?)
    case aiRecommendation(AIRecommendationState)
    case companyInfo(title: String, items: [(title: String, value: String)])
    case keyStats(title: String, stats: [(label: String, value: String)])
    case newsHeader
    case newsArticle(NewsArticle)

    var id: String {
        switch self {
        case .header: return "header"
        case .quote: return "quote"
        case .aiRecommendation: return "ai-recommendation"
        case .companyInfo: return "company-info"
        case .keyStats: return "key-stats"
        case .newsHeader: return "news-header"
        case .newsArticle(let article): return "news-\(article.id)"
        }
    }
}

enum AIRecommendationState: Equatable {
    case loading
    case loaded(StockRecommendation)
    case failed(String)
}
