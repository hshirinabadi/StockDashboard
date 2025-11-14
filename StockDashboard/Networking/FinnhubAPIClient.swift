//
//  FinnhubAPIClient.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

class FinnhubAPIClient {
    
    private let baseURL = "https://finnhub.io/api/v1"
    private let session: URLSession
    private let apiKey: String
    
    static let shared = FinnhubAPIClient()
    
    private init() {
        self.session = URLSession.shared
        self.apiKey = Configuration.finnhubApiKey
    }
    
    init(session: URLSession = .shared) {
        self.session = session
        self.apiKey = Configuration.finnhubApiKey
    }
    
    private func request<T: Decodable>(_ endpoint: String, parameters: [String: String] = [:]) async throws -> T {
        guard var components = URLComponents(string: baseURL + endpoint) else {
            throw FinnhubError.invalidURL
        }
        
        var queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        queryItems.append(URLQueryItem(name: "token", value: apiKey))
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw FinnhubError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FinnhubError.invalidResponse
        }
        
        if (200..<300).contains(httpResponse.statusCode) {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw FinnhubError.decodingFailed(error)
            }
        } else {
            throw FinnhubError.serverError(httpResponse.statusCode)
        }
    }
    
    // MARK: - API Endpoints
    
    func searchSymbol(query: String) async throws -> SymbolLookupResponse {
        return try await request("/search", parameters: ["q": query])
    }
    
    func getQuote(symbol: String) async throws -> Quote {
        return try await request("/quote", parameters: ["symbol": symbol])
    }
    
    func getCompanyProfile(symbol: String) async throws -> CompanyProfile {
        return try await request("/stock/profile2", parameters: ["symbol": symbol])
    }

    func getCompanyNews(symbol: String, from: Date, to: Date) async throws -> [NewsArticle] {
        let fromString = StockDashboardUtils.formatDate(from)
        let toString = StockDashboardUtils.formatDate(to)
        let params = [
            "symbol": symbol,
            "from": fromString,
            "to": toString
        ]
        return try await request("/company-news", parameters: params)
    }
}

