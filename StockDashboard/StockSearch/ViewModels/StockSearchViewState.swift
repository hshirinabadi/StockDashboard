//
//  StockSearchViewState.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

enum StockSearchViewState {
    case initial
    case loading
    case results([SymbolResult])
    case empty(query: String)
    case error(String)
}
