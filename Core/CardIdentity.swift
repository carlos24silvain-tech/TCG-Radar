import Foundation

// MARK: - Universal Card / Printing Identity

struct CardIdentity: Identifiable, Codable {

    let id: UUID

    let name: String
    let game: String

    let confidence: Double

    init(
        id: UUID = UUID(),
        name: String,
        game: String,
        confidence: Double
    ) {
        self.id = id
        self.name = name
        self.game = game
        self.confidence = confidence
    }
}

// MARK: - Specific Card Printing

struct CardPrinting: Identifiable, Codable {

    let id: UUID

    let card: CardIdentity

    let setName: String
    let collectorNumber: String

    let language: String
    let finish: String
    let variant: String

    init(
        id: UUID = UUID(),
        card: CardIdentity,
        setName: String,
        collectorNumber: String,
        language: String,
        finish: String,
        variant: String
    ) {
        self.id = id
        self.card = card
        self.setName = setName
        self.collectorNumber = collectorNumber
        self.language = language
        self.finish = finish
        self.variant = variant
    }
}

// MARK: - Market Pricing

struct PriceObservation: Identifiable, Codable {

    let id: UUID

    let price: Double
    let currency: String

    let source: String
    let observedAt: Date

    init(
        id: UUID = UUID(),
        price: Double,
        currency: String = "USD",
        source: String,
        observedAt: Date = Date()
    ) {
        self.id = id
        self.price = price
        self.currency = currency
        self.source = source
        self.observedAt = observedAt
    }
}


// MARK: - Individual Owned Copy

struct OwnedCardCopy: Identifiable, Codable {

    let id: UUID

    let printing: CardPrinting

    var card: CardIdentity {
        printing.card
    }

    var condition: String?

    var purchasePrice: Double?
    var acquiredAt: Date?
    var acquisitionSource: String?

    var priceHistory: [PriceObservation]

    var gradingAssessment: GradingAssessment?
    var gradingStatus: GradingStatus
    var gradingSubmissions: [GradingSubmission]

    var isForTrade: Bool
    var isForSale: Bool

    init(
        id: UUID = UUID(),
        printing: CardPrinting,
        condition: String? = nil,
        purchasePrice: Double? = nil,
        acquiredAt: Date? = nil,
        acquisitionSource: String? = nil,
        priceHistory: [PriceObservation] = [],
        gradingAssessment: GradingAssessment? = nil,
        gradingStatus: GradingStatus = .raw,
        gradingSubmissions: [GradingSubmission] = [],
        isForTrade: Bool = false,
        isForSale: Bool = false
    ) {
        self.id = id
        self.printing = printing
        self.condition = condition
        self.purchasePrice = purchasePrice
        self.acquiredAt = acquiredAt
        self.acquisitionSource = acquisitionSource
        self.priceHistory = priceHistory
        self.gradingAssessment = gradingAssessment
        self.gradingStatus = gradingStatus
        self.gradingSubmissions = gradingSubmissions
        self.isForTrade = isForTrade
        self.isForSale = isForSale
    }


    var marketValue: Double {
        priceHistory.last?.price ?? 0
    }
}


// MARK: - Card Version Group

struct CardVersionGroup: Identifiable, Codable {

    let id: UUID

    let finish: String
    let variant: String
    let language: String

    var copies: [OwnedCardCopy]
    init(
        id: UUID = UUID(),
        finish: String,
        variant: String,
        language: String,
        copies: [OwnedCardCopy]
    ) {
        self.id = id
        self.finish = finish
        self.variant = variant
        self.language = language
        self.copies = copies
    }

    var quantity: Int {
        copies.count
    }

    var totalValue: Double {
        copies.reduce(0) { total, copy in
            total + copy.marketValue
        }
    }
}


// MARK: - Collection Group

struct CollectionEntry: Identifiable, Codable {

    let id: UUID

    let name: String
    let game: String
    let setName: String
    let collectorNumber: String

    var versions: [CardVersionGroup]
    init(
        id: UUID = UUID(),
        name: String,
        game: String,
        setName: String,
        collectorNumber: String,
        versions: [CardVersionGroup]
    ) {
        self.id = id
        self.name = name
        self.game = game
        self.setName = setName
        self.collectorNumber = collectorNumber
        self.versions = versions
    }
    var totalQuantity: Int {
        versions.reduce(0) { total, version in
            total + version.quantity
        }
    }

    var totalValue: Double {
        versions.reduce(0) { total, version in
            total + version.totalValue
        }
    }
}


// MARK: - Matching Helpers

extension CollectionEntry {

    func matches(_ printing: CardPrinting) -> Bool {
        return name == printing.card.name &&
               game == printing.card.game &&
               setName == printing.setName &&
               collectorNumber == printing.collectorNumber
    }
}


extension CardVersionGroup {

    func matches(_ printing: CardPrinting) -> Bool {
        return finish == printing.finish &&
               variant == printing.variant &&
               language == printing.language
    }
}
