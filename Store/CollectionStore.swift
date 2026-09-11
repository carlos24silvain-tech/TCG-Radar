import SwiftUI
import Combine

@MainActor
final class CollectionStore: ObservableObject {
    
    @Published var cards: [CollectionEntry] = []
    
    
    // MARK: - Add Card
    
    func addCard(_ card: CardIdentity) {
        
        // Find an exi ing collection entry for the same
        // physical printing.
        if let groupIndex = cards.firstIndex(where: {
            $0.matches(card)
        }) {
            
            // Find the matching version.
            if let versionIndex = cards[groupIndex].versions.firstIndex(where: {
                $0.matches(card)
            }) {
                
                let copy = OwnedCardCopy(card: card)
                
                cards[groupIndex].versions[versionIndex].copies.append(copy)
                
            } else {
                
                // Same card, but a new version.
                let newVersion = CardVersionGroup(
                    finish: card.finish,
                    variant: card.variant,
                    language: card.language,
                    copies: [
                        OwnedCardCopy(card: card)
                    ]
                )
                
                cards[groupIndex].versions.append(newVersion)
            }
            
        } else {
            
            // Completely new card.
            let newVersion = CardVersionGroup(
                finish: card.finish,
                variant: card.variant,
                language: card.language,
                copies: [
                    OwnedCardCopy(card: card)
                ]
            )
            
            let newEntry = CollectionEntry(
                name: card.name,
                game: card.game,
                setName: card.setName,
                collectorNumber: card.collectorNumber,
                versions: [newVersion]
            )
            
            cards.append(newEntry)
        }
    }
    
    
    // MARK: - Remove Card
    
    func removeCard(_ card: CollectionEntry) {
        cards.removeAll { $0.id == card.id }
    }
    
    
    // MARK: - Collection Totals
    
    var totalMarketValue: Double {
        cards.reduce(0) { total, card in
            total + card.totalValue
        }
    }
    
    var cardCount: Int {
        cards.reduce(0) { total, card in
            total + card.totalQuantity
        }
    }
}
