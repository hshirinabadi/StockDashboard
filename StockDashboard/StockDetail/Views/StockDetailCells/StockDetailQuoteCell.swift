//
//  StockDetailQuoteView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct StockDetailQuoteView: View {
    let quote: Quote
    let exchange: String?
    let currency: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // In UIKit this was priceLabel + changeLabel side by side using constraints.
            // In SwiftUI, HStack does the same thing declaratively.
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(StockDashboardUtils.formatPrice(quote.currentPrice))
                    .font(.system(size: 34, weight: .semibold))

                Text(StockDashboardUtils.formatChange(quote.change, percentChange: quote.percentChange))
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(quote.percentChange >= 0 ? Color.green : Color.red)
            }

            Text("\(exchange ?? "") · \(currency ?? "USD")")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
