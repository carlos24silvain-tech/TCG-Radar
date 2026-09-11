import SwiftUI

struct CardCopiesView: View {
    
    let version: CardVersionGroup
    
    var body: some View {
        
        List {
            
            Section {
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text(version.finish.capitalized)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if version.variant != "Standard" {
                            Text(version.variant)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text(version.language.uppercased())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        
                        Text("QTY \(version.quantity)")
                            .font(.headline)
                        
                        Text(
                            String(
                                format: "$%.2f",
                                version.totalValue
                            )
                        )
                        .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section("Individual Copies") {
                
                ForEach(
                    Array(version.copies.enumerated()),
                    id: \.element.id
                ) { index, copy in
                    
                    NavigationLink {
                        IndividualCopyView(copy: copy)
                    } label: {
                        
                        HStack {
                            
                            VStack(
                                alignment: .leading,
                                spacing: 5
                            ) {
                                
                                Text("Copy \(index + 1)")
                                    .font(.headline)
                                
                                Text(copy.card.name)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text("#\(copy.printing.collectorNumber)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(
                                String(
                                    format: "$%.2f",
                                    copy.marketValue
                                )
                            )
                            .font(.headline)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .navigationTitle("Copies")
        .navigationBarTitleDisplayMode(.inline)
    }
}
