//
//  StockService.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

class StockService: StockServiceProtocol {
    private let apiClient: FinnhubAPIClient
    
    init(apiClient: FinnhubAPIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func searchSymbols(query: String) async throws -> [SymbolResult] {
        let response = try await apiClient.searchSymbol(query: query)
        return response.result
    }
    
    func getQuote(for symbol: String) async throws -> Quote {
        return try await apiClient.getQuote(symbol: symbol)
    }
    
    func getCompanyProfile(for symbol: String) async throws -> CompanyProfile {
        return try await apiClient.getCompanyProfile(symbol: symbol)
    }

    func getCompanyNews(for symbol: String, from: Date, to: Date) async throws -> [NewsArticle] {
        return try await apiClient.getCompanyNews(symbol: symbol, from: from, to: to)
    }
}
