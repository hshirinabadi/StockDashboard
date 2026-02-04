//
//  StockDetailScreen.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct StockDetailScreen: View {
    // @StateObject creates and owns the ViewModel — same as the ViewController's
    // "private let viewModel: StockDetailViewModel" but with auto-subscription.
    @StateObject private var viewModel: StockDetailViewModel

    init(symbol: String) {
        // _viewModel wraps the value in a StateObject. This is how you pass
        // init parameters to a @StateObject.
        _viewModel = StateObject(wrappedValue: StockDetailViewModel(symbol: symbol))
    }

    var body: some View {
        // The switch replaces the UIKit pattern of toggling isHidden on
        // loadingStateView, errorStateView, and collectionView.
        Group {
            switch viewModel.viewState.state {
            case .loading:
                LoadingStateView()

            case .error(let message):
                ErrorStateView(message: message)

            case .loaded:
                loadedContent
            }
        }
        // .onAppear/.onDisappear replace viewWillAppear/viewWillDisappear.
        .onAppear { viewModel.startPricePolling() }
        .onDisappear { viewModel.stopPricePolling() }
    }

    // This single ScrollView + VStack replaces:
    // - UICollectionView with compositional layout
    // - UICollectionViewDiffableDataSource + Snapshot
    // - 7 SectionController classes
    // - Cell registration + dequeue
    // Each section is just a view — no section identifiers, no items, no layout callbacks.
    private var loadedContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header section
                StockDetailHeaderView(
                    symbol: viewModel.viewState.symbol,
                    companyName: viewModel.viewState.companyProfile?.name
                )

                // Quote section
                if let quote = viewModel.viewState.quote {
                    StockDetailQuoteView(
                        quote: quote,
                        exchange: viewModel.viewState.companyProfile?.exchange,
                        currency: viewModel.viewState.companyProfile?.currency
                    )
                }

                // AI Recommendation section
                StockDetailAIRecommendationView(
                    state: viewModel.viewState.recommendationState
                )

                // Company Info section
                if let profile = viewModel.viewState.companyProfile {
                    StockDetailInfoView(
                        title: "Company Info",
                        infoItems: companyInfoItems(from: profile)
                    )
                }

                // Key Stats section
                if let quote = viewModel.viewState.quote {
                    StockDetailKeyStatsView(
                        title: "Key Statistics",
                        stats: keyStatsItems(from: quote)
                    )
                }

                // News section
                if !viewModel.viewState.news.isEmpty {
                    StockDetailNewsHeaderView()
                    ForEach(viewModel.viewState.news, id: \.id) { article in
                        StockDetailNewsRowView(article: article)
                    }
                }
            }
        }
    }

    // Helper to build company info items — this logic was previously in a SectionController
    private func companyInfoItems(from profile: CompanyProfile) -> [(title: String, value: String)] {
        var items: [(title: String, value: String)] = []
        if let industry = profile.finnhubIndustry { items.append(("Industry", industry)) }
        if let exchange = profile.exchange { items.append(("Exchange", exchange)) }
        if let marketCap = profile.marketCapitalization {
            items.append(("Market Cap", StockDashboardUtils.formatMarketCap(marketCap)))
        }
        items.append(("P/E Ratio", "—"))
        return items
    }

    private func keyStatsItems(from quote: Quote) -> [(label: String, value: String)] {
        [
            ("Open", StockDashboardUtils.formatPrice(quote.open)),
            ("High", StockDashboardUtils.formatPrice(quote.high)),
            ("Low", StockDashboardUtils.formatPrice(quote.low)),
            ("Prev Close", StockDashboardUtils.formatPrice(quote.previousClose)),
        ]
    }
}
