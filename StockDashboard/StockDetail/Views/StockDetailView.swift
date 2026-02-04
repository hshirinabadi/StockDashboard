//
//  StockDetailScreen.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct StockDetailScreen: View {
    @StateObject private var viewModel: StockDetailViewModel

    init(symbol: String) {
        _viewModel = StateObject(wrappedValue: StockDetailViewModel(symbol: symbol))
    }

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                LoadingStateView()

            case .error(let message):
                ErrorStateView(message: message)

            case .loaded(let sections):
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(sections) { section in
                            sectionView(for: section)
                        }
                    }
                }
            }
        }
        .onAppear { viewModel.startPricePolling() }
        .onDisappear { viewModel.stopPricePolling() }
    }

    @ViewBuilder
    private func sectionView(for section: StockDetailSection) -> some View {
        switch section {
        case .header(let symbol, let companyName):
            StockDetailHeaderView(symbol: symbol, companyName: companyName)
        case .quote(let quote, let exchange, let currency):
            StockDetailQuoteView(quote: quote, exchange: exchange, currency: currency)
        case .aiRecommendation(let state):
            StockDetailAIRecommendationView(state: state)
        case .companyInfo(let title, let items):
            StockDetailInfoView(title: title, infoItems: items)
        case .keyStats(let title, let stats):
            StockDetailKeyStatsView(title: title, stats: stats)
        case .newsHeader:
            StockDetailNewsHeaderView()
        case .newsArticle(let article):
            StockDetailNewsRowView(article: article)
        }
    }
}
