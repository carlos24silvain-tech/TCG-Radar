//
//  CardDetailsView.swift
//  TCG Radar
//
//  Created by carlos silvain on 9/11/26.
//

import SwiftUI

// MARK: - Card Details

struct CardDetailsView: View {
    
    let entry: CollectionEntry
    
    var body: some View {
        List {
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(entry.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(entry.game)
                        .foregroundStyle(.secondary)
                    
                    Text(entry.setName)
                        .foregroundStyle(.secondary)
                    
                    Text("#\(entry.collectorNumber)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            
            Section("Collection Summary") {
                
                HStack {
                    Text("Total Quantity")
                    
                    Spacer()
                    
                    Text("\(entry.totalQuantity)")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Total Value")
                    
                    Spacer()
                    
                    Text(
                        String(
                            format: "$%.2f",
                            entry.totalValue
                        )
                    )
                    .fontWeight(.semibold)
                }
            }
            
            
            Section("Versions Owned") {
                
                ForEach(entry.versions) { version in
                    
                    NavigationLink(
                        destination: CardCopiesView(version: version)
                    ) {
                        HStack {
                            
                            VStack(alignment: .leading, spacing: 4) {
                                
                                Text(version.finish.capitalized)
                                    .font(.headline)
                                
                                if version.variant != "Standard" {
                                    Text(version.variant)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Text(version.language.uppercased())
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                
                                Text("×\(version.quantity)")
                                    .fontWeight(.semibold)
                                
                                Text(
                                    String(
                                        format: "$%.2f",
                                        version.totalValue
                                    )
                                )
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Card Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

