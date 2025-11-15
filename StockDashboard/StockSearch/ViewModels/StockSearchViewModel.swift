//
//  StockSearchViewModel.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation
import Combine

@MainActor
class StockSearchViewModel {
   
    @Published private(set) var viewState: StockSearchViewState = .initial
    @Published private var searchQuery = ""
    
    // Public publisher for the view state that views can subscribe to
    var viewStatePublisher: AnyPublisher<StockSearchViewState, Never> {
        return $viewState.eraseToAnyPublisher()
    }
    
    
    private var searchResults: [SymbolResult] = []
    
    private let stockService: StockServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    private var searchTask: Task<Void, Never>?
    
    // Debounce delay for search queries
    private let searchDebounceDelay: TimeInterval = 0.5
    
    init(stockService: StockServiceProtocol = StockService()) {
        self.stockService = stockService
        setupBindings()
    }
    
    func setSearchQuery(_ query: String) {
        searchQuery = query
    }
    
    private func setupBindings() {
        $searchQuery
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty {
                    self.searchTask?.cancel()
                    self.searchTask = nil
                }
                self.updateViewStateWithQuery(query)
            }
            .store(in: &cancellables)
        
        // Debounce search for API calls
        $searchQuery
            .removeDuplicates()
            .debounce(for: .seconds(searchDebounceDelay), scheduler: RunLoop.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                self?.searchSymbols(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func searchSymbols(query: String) {
        searchTask?.cancel()
        searchTask = Task {
            do {
                try Task.checkCancellation()
                
                updateViewStateToLoading()
                
                try Task.checkCancellation()
                
                let symbols = try await stockService.searchSymbols(query: query)
                
                try Task.checkCancellation()
                
                searchResults = symbols
                updateViewStateWithSymbols(symbols)
                
            } catch {
                if Task.isCancelled { return }
                if (error as? URLError)?.code == .cancelled { return }
                updateViewStateWithError(error.localizedDescription)
            }
        }
    }
    
    private func updateViewStateWithQuery(_ query: String) {
        var newState = viewState
        newState.updateSearchQuery(query)
        viewState = newState
    }
    
    private func updateViewStateWithSymbols(_ symbols: [SymbolResult]) {
        var newState = viewState
        newState.updateWithSymbols(symbols)
        viewState = newState
    }
    
    private func updateViewStateWithError(_ errorMessage: String) {
        var newState = viewState
        newState.updateWithError(errorMessage)
        viewState = newState
    }
    
    private func updateViewStateToLoading() {
        var newState = viewState
        newState.updateToLoadingState()
        viewState = newState
    }
    
    private func resetToInitialState() {
        searchResults = []
        viewState = .initial
    }
}
