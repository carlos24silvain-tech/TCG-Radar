//
//  DropView.swift
//  TCG Radar
//
//  Created by carlos silvain on 9/11/26.
//

import Foundation
import SwiftUI

// MARK: - Drops

struct DropsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Drop Radar") {
                    DropRow(
                        game: "Pokémon",
                        product: "Mega Evolution",
                        retailer: "Target",
                        status: "WATCH"
                    )
                    
                    DropRow(
                        game: "Magic: The Gathering",
                        product: "Commander Collection",
                        retailer: "Best Buy",
                        status: "SOON"
                    )
                    
                    DropRow(
                        game: "One Piece",
                        product: "Booster Box",
                        retailer: "GameStop",
                        status: "LIVE"
                    )
                }
            }
            .navigationTitle("Drop Radar")
        }
    }
}
