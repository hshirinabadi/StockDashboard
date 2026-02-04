//
//  StockDetailNewsHeaderView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct StockDetailNewsHeaderView: View {
    var body: some View {
        Text("Latest News")
            .font(.system(size: 20, weight: .semibold))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
