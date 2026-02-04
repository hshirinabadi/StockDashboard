//
//  StockDetailInfoView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct StockDetailInfoView: View {
    let title: String
    let infoItems: [(title: String, value: String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 20, weight: .semibold))

            // In UIKit, each row was a UIView with two UILabels + 8 constraints.
            // In SwiftUI, each row is an HStack with two Texts — no constraints needed.
            ForEach(infoItems.indices, id: \.self) { index in
                HStack {
                    Text(infoItems[index].title)
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(infoItems[index].value)
                        .font(.system(size: 16))
                }
                .padding(.vertical, 4)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
        )
    }
}
