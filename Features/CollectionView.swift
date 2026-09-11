//
//  CollectionView.swift
//  TCG Radar
//
//  Created by carlos silvain on 9/11/26.
//

import Foundation
import SwiftUI

// MARK: - Collection
struct CollectionView: View {
    
    @EnvironmentObject private var collectionStore: CollectionStore
    
    var body: some View {
        NavigationStack {
            
            List {
                
                Section {
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text("Total Value")
                                .foregroundStyle(.secondary)
                            
                            Text(
                                String(
                                    format: "$%.2f",
                                    collectionStore.totalMarketValue
                                )
                            )
                            .font(.system(size: 34, weight: .bold))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            
                            Text("Cards")
                                .foregroundStyle(.secondary)
                            
                            Text("\(collectionStore.cardCount)")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                
                Section("My Cards") {
                    
                    if collectionStore.cards.isEmpty {
                        
                        VStack(spacing: 10) {
                            
                            Image(systemName: "rectangle.stack")
                                .font(.system(size: 40))
                                .foregroundStyle(.secondary)
                            
                            Text("No cards scanned yet")
                                .font(.headline)
                            
                            Text("Verified cards will appear here automatically.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        
                    } else {
                        
                        ForEach(collectionStore.cards) { entry in
                            
                            NavigationLink {
                                CardDetailsView(entry: entry)
                            } label: {
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    
                                    HStack {
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            
                                            Text(entry.name)
                                                .font(.headline)
                                            
                                            Text(entry.game)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 2) {
                                            
                                            Text(
                                                String(
                                                    format: "$%.2f",
                                                    entry.totalValue
                                                )
                                            )
                                            .font(.headline)
                                            
                                            Text("QTY \(entry.totalQuantity)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    
                                    Text(entry.setName)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    
                                    Text("#\(entry.collectorNumber)")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                    
                                    ForEach(entry.versions) { version in
                                        
                                        HStack {
                                            
                                            Text(version.finish.capitalized)
                                            
                                            if version.variant != "Standard" {
                                                Text("•")
                                                Text(version.variant)
                                            }
                                            
                                            Text("×\(version.quantity)")
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Text(
                                                String(
                                                    format: "$%.2f",
                                                    version.totalValue
                                                )
                                            )
                                            .foregroundStyle(.secondary)
                                        }
                                        .font(.caption)
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Collection")
        }
    }
}
