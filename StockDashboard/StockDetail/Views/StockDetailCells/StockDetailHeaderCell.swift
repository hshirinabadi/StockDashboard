//
//  StockDetailHeaderView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct StockDetailHeaderView: View {
    let symbol: String
    let companyName: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(symbol)
                .font(.system(size: 36, weight: .bold))

            Text(companyName ?? "Loading...")
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
