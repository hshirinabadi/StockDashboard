//
//  StockService.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

class StockService: StockServiceProtocol {
    private let apiClient: FinnhubAPIClient
    
    init(apiClient: FinnhubAPIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func searchSymbols(query: String) async throws -> [SymbolResult] {
        let response = try await apiClient.searchSymbol(query: query)
        return response.result
    }
}
