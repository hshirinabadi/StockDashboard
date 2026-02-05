//
//  StockDetailSectionBuilder.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

struct StockDetailSectionBuilder {

    func buildSections(
        symbol: String,
        quote: Quote?,
        profile: CompanyProfile?,
        news: [NewsArticle],
        recommendationState: AIRecommendationState
    ) -> [StockDetailSection] {
        var sections: [StockDetailSection] = []

        sections.append(.header(symbol: symbol, companyName: profile?.name))

        if let quote {
            sections.append(.quote(
                quote: quote,
                exchange: profile?.exchange,
                currency: profile?.currency
            ))
        }

        sections.append(.aiRecommendation(recommendationState))

        if let profile {
            sections.append(.companyInfo(
                title: "Company Info",
                items: companyInfoItems(from: profile)
            ))
        }

        if let quote {
            sections.append(.keyStats(
                title: "Key Statistics",
                stats: keyStatsItems(from: quote)
            ))
        }

        if !news.isEmpty {
            sections.append(.newsHeader)
            for article in news {
                sections.append(.newsArticle(article))
            }
        }

        return sections
    }

    // MARK: - Private

    private func companyInfoItems(from profile: CompanyProfile) -> [(title: String, value: String)] {
        var items: [(title: String, value: String)] = []
        if let industry = profile.finnhubIndustry { items.append(("Industry", industry)) }
        if let exchange = profile.exchange { items.append(("Exchange", exchange)) }
        if let marketCap = profile.marketCapitalization {
            items.append(("Market Cap", StockDashboardUtils.formatMarketCap(marketCap)))
        }
        items.append(("P/E Ratio", "\u{2014}"))
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
