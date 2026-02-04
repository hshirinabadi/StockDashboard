//
//  StockSearchViewModel.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

@MainActor
class StockSearchViewModel: ObservableObject {

    @Published private(set) var viewState: StockSearchViewState = .initial

    private let stockService: StockServiceProtocol
    private var searchTask: Task<Void, Never>?

    init(stockService: StockServiceProtocol = StockService()) {
        self.stockService = stockService
    }

    func setSearchQuery(_ query: String) {
        searchTask?.cancel()
        
        guard !query.isEmpty else {
            viewState = .initial
            return
        }

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard !Task.isCancelled else { return }

            viewState = .loading

            do {
                let symbols = try await stockService.searchSymbols(query: query)
                guard !Task.isCancelled else { return }
                viewState = symbols.isEmpty ? .empty(query: query) : .results(symbols)
            } catch {
                guard !Task.isCancelled else { return }
                if (error as? URLError)?.code == .cancelled { return }
                viewState = .error(error.localizedDescription)
            }
        }
    }
}
