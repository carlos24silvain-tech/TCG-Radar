//
//  AnalyticsView.swift
//  TCG Radar
//
//  Created by carlos silvain on 9/11/26.
//

import Foundation
import SwiftUI

// MARK: - AI Analytics
struct AnalyticsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.largeTitle)
                            .foregroundStyle(.purple)

                        VStack(alignment: .leading) {
                            Text("AI Market Intelligence")
                                .font(.title2.bold())

                            Text("Signals from your market data")
                                .foregroundStyle(.secondary)
                        }
                    }

                    AnalyticsCard(
                        title: "Market Momentum",
                        value: "Bullish",
                        detail: "Trading activity is increasing across tracked cards."
                    )

                    AnalyticsCard(
                        title: "Best Opportunity",
                        value: "Charizard ex",
                        detail: "Strong demand with positive recent movement."
                    )

                    AnalyticsCard(
                        title: "Risk Watch",
                        value: "Low",
                        detail: "Current collection exposure is relatively balanced."
                    )
                }
                .padding()
            }
            .navigationTitle("AI")
        }
    }
}
