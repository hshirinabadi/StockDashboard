//
//  StockRecommendation.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/16/25.
//

enum StockRecommendationAction: String, Codable {
    case buy = "BUY"
    case hold = "HOLD"
    case sell = "SELL"
}

struct StockRecommendation: Equatable {
    let action: StockRecommendationAction
    let confidence: Double
    let rationale: String
}

struct RecommendationPayload: Decodable {
    let action: StockRecommendationAction
    let confidence: Double
    let rationale: String
}
