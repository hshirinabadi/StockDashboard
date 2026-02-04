//
//  StockSearchView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct StockSearchView: View {
    // @StateObject creates and owns the ViewModel.
    // This is the SwiftUI equivalent of "private let viewModel = StockSearchViewModel()"
    // in the UIViewController, but SwiftUI also auto-subscribes to @Published changes.
    @StateObject private var viewModel = StockSearchViewModel()

    // @State is for local view state. This replaces UISearchController's search bar text.
    @State private var searchText = ""

    var body: some View {
        Group {
            switch viewModel.viewState.state {
            case .initial:
                EmptyStateView(message: "Search for a company or ticker symbol")

            case .loading:
                LoadingStateView()

            case .results:
                List(viewModel.viewState.symbols, id: \.symbol) { symbol in
                    NavigationLink(value: symbol) {
                        SearchSymbolRow(symbolResult: symbol)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(.plain)
                .scrollDismissesKeyboard(.interactively)

            case .empty(let message):
                EmptyStateView(message: "No results found for \"\(message)\"")

            case .error(let message):
                ErrorStateView(message: message)
            }
        }
        .navigationTitle("Stock Search")
        .searchable(text: $searchText)
        .onChange(of: searchText) { newValue in
            viewModel.setSearchQuery(newValue)
        }
        .navigationDestination(for: SymbolResult.self) { symbol in
            StockDetailScreen(symbol: symbol.symbol)
                .navigationTitle(symbol.description)
        }
    }
}
