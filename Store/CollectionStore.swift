import SwiftUI
import Combine

@MainActor
final class CollectionStore: ObservableObject {

    @Published var cards: [CollectionEntry] = []


    // MARK: - Add Card

    func addCard(
        _ card: CardIdentity,
        printing: CardPrinting,
        priceObservation: PriceObservation? = nil
    ) {

       

        let priceHistory: [PriceObservation]

        if let priceObservation {
            priceHistory = [priceObservation]
        } else {
            priceHistory = []
        }

        let newCopy = OwnedCardCopy(
            printing: printing,
            priceHistory: priceHistory
        )

        if let groupIndex = cards.firstIndex(where: {
            $0.matches(printing)
        }) {

            // Same printing + same version.
            if let versionIndex = cards[groupIndex].versions.firstIndex(where: {
                $0.matches(printing)
            }) {

                cards[groupIndex]
                    .versions[versionIndex]
                    .copies
                    .append(newCopy)

            } else {

                // Same printing, different finish / variant / language.
                let newVersion = CardVersionGroup(
                    finish: printing.finish,
                    variant: printing.variant,
                    language: printing.language,
                    copies: [newCopy]
                )

                cards[groupIndex].versions.append(newVersion)
            }

        } else {

            // Completely new collection entry.
            let newVersion = CardVersionGroup(
                finish: printing.finish,
                variant: printing.variant,
                language: printing.language,
                copies: [newCopy]
            )

            let newEntry = CollectionEntry(
                name: card.name,
                game: card.game,
                setName: printing.setName,
                collectorNumber: printing.collectorNumber,
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
