import Foundation

struct CardIdentity: Identifiable {
    
    let id = UUID()
    
    let name: String
    let game: String
    let setName: String
    let collectorNumber: String
    
    let language: String
    let finish: String
    let variant: String
    
    let confidence: Double
    let marketValue: Double
}


// MARK: - Individual Owned Copy

struct OwnedCardCopy: Identifiable {
    
    let id = UUID()
    
    let card: CardIdentity
    
    var marketValue: Double {
        card.marketValue
    }
}
// MARK: - Grading

var gradingAssessment: GradingAssessment?

var gradingStatus: GradingStatus = .raw

var gradingSubmissions: [GradingSubmission] = []

// MARK: - Card Version Group

struct CardVersionGroup: Identifiable {
    
    let id = UUID()
    
    let finish: String
    let variant: String
    let language: String
    
    var copies: [OwnedCardCopy]
    
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

struct CollectionEntry: Identifiable {
    
    let id = UUID()
    
    let name: String
    let game: String
    let setName: String
    let collectorNumber: String
    
    var versions: [CardVersionGroup]
    
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
}// MARK: - Matching Helpers

extension CollectionEntry {
    
    func matches(_ card: CardIdentity) -> Bool {
        return name == card.name &&
               game == card.game &&
               setName == card.setName &&
               collectorNumber == card.collectorNumber
    }
}


extension CardVersionGroup {
    
    func matches(_ card: CardIdentity) -> Bool {
        return finish == card.finish &&
               variant == card.variant &&
               language == card.language
    }
}
