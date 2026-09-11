//
//  ScanView.swift
//  TCG Radar
//
//  Created by carlos silvain on 9/11/26.
//

import Foundation
import SwiftUI

struct ScanView: View {
    
    @EnvironmentObject private var collectionStore: CollectionStore
    
    
    @State private var recognizedText = ""
    @State private var verifiedCard: CardIdentity?
    @State private var verifiedPrinting: CardPrinting?
    @State private var isVerifying = false
    @State private var verificationMessage = ""
    
    private var possibleCardName: String {
        let lines = recognizedText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        return lines.first ?? ""
    }
    
    var body: some View {
        ZStack {
            
            CameraScannerView(
                recognizedText: $recognizedText
            )
            .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("TCG RADAR")
                        .font(.headline)
                    
                    if let card = verifiedCard,
                       let printing = verifiedPrinting {
                        
                        Text("VERIFIED CARD")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                        
                        Text(card.name)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Divider()
                        
                        HStack {
                            Text("Game")
                            Spacer()
                            Text(card.game)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Set")
                            Spacer()
                            Text(printing.setName)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Collector #")
                            Spacer()
                            Text(printing.collectorNumber)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Language")
                            Spacer()
                            Text(printing.language)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Finish")
                            Spacer()
                            Text(printing.finish)
                                .foregroundStyle(.secondary)
                        }
                        
                        
                        
                        Button("SCAN ANOTHER CARD") {
                            verifiedCard = nil
                            verifiedPrinting = nil
                            verificationMessage = ""
                        }
                        .buttonStyle(.borderedProminent)
                        
                    } else if possibleCardName.isEmpty {
                        
                        Text("Point your camera at a card...")
                            .foregroundStyle(.secondary)
                        
                    } else {
                        
                        Text("POSSIBLE CARD MATCH")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        
                        Text(possibleCardName)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("OCR detected the card name.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Button {
                            verifyCard()
                        } label: {
                            if isVerifying {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("VERIFY CARD")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isVerifying)
                        
                        if !verificationMessage.isEmpty {
                            Text(verificationMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding()
            }
        }
    }
    
    private func verifyCard() {
        
        guard !possibleCardName.isEmpty else {
            return
        }
        
        isVerifying = true
        verificationMessage = ""
        
        Task {
            do {
                let result = try await ScryfallService.shared.searchCard(
                    named: possibleCardName
                )
                
                await MainActor.run {
                    collectionStore.addCard(
                        result.card,
                        printing: result.printing,
                        priceObservation: result.priceObservation
                    )
                    
                    verifiedCard = result.card
                    verifiedPrinting = result.printing
                    isVerifying = false
                }
                
            } catch {
                
                await MainActor.run {
                    verificationMessage =
                    "Card verification failed. Try scanning again."
                    
                    isVerifying = false
                }
            }
        }
    }
}
