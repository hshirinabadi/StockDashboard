//
//  TestView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 2/4/26.
//

import SwiftUI

struct TestEntryView: View {
    
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .navigationTitle("Stock Dashboard")
    }
}

#Preview {
    NavigationStack {
        TestEntryView()
    }
//    TestEntryView()
}
