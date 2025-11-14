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
