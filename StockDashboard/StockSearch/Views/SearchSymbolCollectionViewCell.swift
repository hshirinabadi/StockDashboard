//
//  SearchSymbolRow.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct SearchSymbolRow: View {
    let symbolResult: SymbolResult

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(symbolResult.symbol)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.primary)

            Text(symbolResult.description)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .lineLimit(2)

            Text(symbolResult.type)
                .font(.system(size: 12))
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
        )
        .padding(4)
    }
}
