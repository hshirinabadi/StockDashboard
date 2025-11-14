//
//  FinnhubModels.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

struct SymbolLookupResponse: Decodable {
    let count: Int
    let result: [SymbolResult]
}

struct SymbolResult: Decodable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}

struct Quote: Decodable {
    let currentPrice: Double
    let change: Double
    let percentChange: Double
    let high: Double
    let low: Double
    let open: Double
    let previousClose: Double
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case change = "d"
        case percentChange = "dp"
        case high = "h"
        case low = "l"
        case open = "o"
        case previousClose = "pc"
    }
}

struct CompanyProfile: Decodable {
    let country: String?
    let currency: String?
    let exchange: String?
    let ipo: String?
    let marketCapitalization: Double?
    let name: String?
    let phone: String?
    let shareOutstanding: Double?
    let ticker: String?
    let weburl: String?
    let logo: String?
    let finnhubIndustry: String?
}

struct NewsArticle: Decodable {
    let category: String?
    let datetime: Int
    let headline: String
    let id: Int
    let image: String?
    let related: String?
    let source: String
    let summary: String?
    let url: String
    
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(datetime))
    }
}
