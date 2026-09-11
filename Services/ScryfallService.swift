import Foundation

final class ScryfallService {
    
    static let shared = ScryfallService()
    
    private init() {}
    
    func searchCard(named name: String) async throws -> CardIdentity {
        
        let encodedName = name.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? name
        
        let urlString = "https://api.scryfall.com/cards/named?fuzzy=\(encodedName)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(
            "TCG Radar/1.0",
            forHTTPHeaderField: "User-Agent"
        )
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )
        
        let (data, response) = try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let card = try JSONDecoder().decode(
            ScryfallCard.self,
            from: data
        )
        
        return CardIdentity(
            name: card.name,
            game: "Magic: The Gathering",
            setName: card.setName,
            collectorNumber: card.collectorNumber,
            language: card.language,
            finish: card.finishes.first ?? "Unknown",
            variant: "Standard",
            confidence: 1.0,
            marketValue: card.prices.usd.flatMap(Double.init) ?? 0.0
        )
    }
}

private struct ScryfallCard: Decodable {
    
    let name: String
    let setName: String
    let collectorNumber: String
    let language: String
    let finishes: [String]
    let prices: ScryfallPrices
    
    enum CodingKeys: String, CodingKey {
        case name
        case setName = "set_name"
        case collectorNumber = "collector_number"
        case language = "lang"
        case finishes
        case prices
    }
}

private struct ScryfallPrices: Decodable {
    let usd: String?
}
