import SwiftUI

struct IndividualCopyView: View {
    
    let copy: OwnedCardCopy
    
    var body: some View {
        
        List {
            
            Section("Card Information") {
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(copy.card.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(copy.card.game)
                        .foregroundStyle(.secondary)
                    
                    Text(copy.printing.setName)                        .foregroundStyle(.secondary)
                    
                    Text("#\(copy.printing.collectorNumber)")                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            
            Section("Printing") {
                
                LabeledContent(
                    "Language",
                    value: copy.printing.language.uppercased()
                )
                
                LabeledContent(
                    "Finish",
                    value: copy.printing.finish.capitalized                )
                
                LabeledContent(
                    "Variant",
                    value: copy.printing.variant
                )
            }
            
            Section("Market Value") {
                
                HStack {
                    
                    Text("Current Value")
                    
                    Spacer()
                    
                    Text(
                        String(
                            format: "$%.2f",
                            copy.marketValue
                        )
                    )
                    .fontWeight(.bold)
                }
            }
            
            Section("AI Grading Estimate") {
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Label(
                        "Professional Grade Analysis",
                        systemImage: "sparkles"
                    )
                    .font(.headline)
                    
                    Text(
                        "TCG Radar will analyze the front, back, corners, edges, surface, centering, and visible defects to estimate possible PSA and CGC grades."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    Text(
                        "No grading estimate has been performed for this copy yet."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
                
                NavigationLink {
                    GradingAnalysisView(copy: copy)
                } label: {
                    Label(
                        "Analyze Card for Grading",
                        systemImage: "wand.and.stars"
                    )
                }
            }
            
            Section("Grading Disclaimer") {
                
                Text(
                    "TCG Radar grading results are estimates only and are not official grades, guarantees, appraisals, or authentication results. Actual grades are determined solely by the selected professional grading company."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Individual Copy")
        .navigationBarTitleDisplayMode(.inline)
    }
}
