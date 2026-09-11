import Foundation
import SwiftUI
import Combine

@MainActor
final class CollectionStore: ObservableObject {
             
    @Published var cards: [CollectionEntry] = []
    init() {
        loadCollection()
    }
    private let saveFileName = "collection.json"

    private var saveURL: URL {
        let fileManager = FileManager.default

        let applicationSupport = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]

        let appDirectory = applicationSupport.appendingPathComponent(
            "TCGRadar",
            isDirectory: true
        )

        try? fileManager.createDirectory(
            at: appDirectory,
            withIntermediateDirectories: true
        )

        return appDirectory.appendingPathComponent(saveFileName)
    }
    // MARK: - Load Collection

    func loadCollection() {
        let url = saveURL

        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedCards = try JSONDecoder().decode(
                [CollectionEntry].self,
                from: data
            )

            cards = decodedCards

        } catch {
            print("Failed to load collection: \(error)")
        }
    }
    
    // MARK: - Save Collection

    func saveCollection() {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(
                to: saveURL,
                options: .atomic
            )

        } catch {
            print("Failed to save collection: \(error)")
        }
    }
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

            saveCollection()
            }

    // MARK: - Remove Card

    func removeCard(_ card: CollectionEntry) {
        cards.removeAll { $0.id == card.id }
        saveCollection()
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
