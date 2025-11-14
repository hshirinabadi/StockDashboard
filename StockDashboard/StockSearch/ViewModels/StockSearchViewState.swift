//
//  StockSearchViewState.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

struct StockSearchViewState {
    
    enum State {
        case initial
        case loading
        case results(symbols: [SymbolResult])
        case empty(message: String)
        case error(message: String)
    }
    
    var state: State
    var symbols: [SymbolResult]
    var searchQuery: String
    
    static var initial: StockSearchViewState {
        return StockSearchViewState(
            state: .initial,
            symbols: [],
            searchQuery: ""
        )
    }
    
    var hasResults: Bool {
        return !symbols.isEmpty
    }
    
    mutating func updateToLoadingState() {
        state = .loading
    }
    
    mutating func updateWithError(_ errorMessage: String) {
        state = .error(message: errorMessage)
    }
    
    mutating func updateWithSymbols(_ symbols: [SymbolResult]) {
        self.symbols = symbols
        state = hasResults ? .results(symbols: symbols) : .empty(message: searchQuery)
    }
    
    mutating func updateSearchQuery(_ query: String) {
        self.searchQuery = query
        if query.isEmpty {
            state = .initial
        }
    }
}
