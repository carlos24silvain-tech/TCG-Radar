//
//  HomeView.swift.swift
//  TCG Radar
//
//  Created by carlos silvain on 9/11/26.
//

import Foundation
import SwiftUI

// MARK: - Home

struct HomeView: View {
    @Binding var huntMode: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TCG RADAR")
                                .font(.largeTitle.bold())

                            Text("Your collection. Your edge.")
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "dot.radiowaves.left.and.right")
                            .font(.system(size: 30))
                            .foregroundStyle(.orange)
                    }

                    HStack {
                        Image(systemName: "scope")
                            .foregroundStyle(.orange)

                        VStack(alignment: .leading) {
                            Text("Hunt Mode")
                                .font(.headline)

                            Text("Find opportunities automatically")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Toggle("", isOn: $huntMode)
                            .labelsHidden()
                    }
                    .padding()
                    .background(.orange.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    HStack(spacing: 12) {
                        MetricCard(
                            title: "Collection",
                            value: "$12,482",
                            icon: "square.stack.3d.up.fill"
                        )

                        MetricCard(
                            title: "Today's Moves",
                            value: "+8.4%",
                            icon: "chart.line.uptrend.xyaxis"
                        )
                    }

                    Text("LIVE DROPS")
                        .font(.headline)

                    OpportunityCard(
                        title: "Pokémon Mega Evolution",
                        subtitle: "Target release detected",
                        value: "HIGH",
                        icon: "bolt.fill"
                    )

                    OpportunityCard(
                        title: "One Piece Booster Box",
                        subtitle: "Price dropped 14%",
                        value: "BUY",
                        icon: "arrow.down.circle.fill"
                    )

                    Text("BIGGEST MOVERS")
                        .font(.headline)

                    HStack {
                        MoverRow(name: "Charizard ex", change: "+18.2%")
                        Spacer()
                        MoverRow(name: "Pikachu", change: "+11.7%")
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}
