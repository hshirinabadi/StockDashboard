//
//  StockRecommendationServiceProtocol.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/16/25.
//

protocol StockRecommendationServiceProtocol {
    func recommendation(
        for symbol: String,
        quote: Quote,
        profile: CompanyProfile?,
        news: [NewsArticle]
    ) async throws -> StockRecommendation
}
