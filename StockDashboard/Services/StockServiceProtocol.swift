//
//  StockServiceProtocol.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

protocol StockServiceProtocol {
    func searchSymbols(query: String) async throws -> [SymbolResult]
    func getQuote(for symbol: String) async throws -> Quote
    func getCompanyProfile(for symbol: String) async throws -> CompanyProfile
    func getCompanyNews(for symbol: String, from: Date, to: Date) async throws -> [NewsArticle]
}
