//
//  StockServiceProtocol.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

protocol StockServiceProtocol {
    func searchSymbols(query: String) async throws -> [SymbolResult]
}
