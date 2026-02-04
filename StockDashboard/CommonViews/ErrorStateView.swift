//
//  ErrorStateView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String

    var body: some View {
        VStack(spacing: 8) {
            Text("Something went wrong")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.primary)

            Text(message)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
