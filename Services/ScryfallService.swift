import Foundation

// MARK: - Card Lookup Result

struct CardLookupResult {

    let card: CardIdentity
    let printing: CardPrinting
    let priceObservation: PriceObservation?
}


// MARK: - Scryfall Service

final class ScryfallService {

    static let shared = ScryfallService()

    private init() {}


    func searchCard(named name: String) async throws -> CardLookupResult {

        let encodedName = name.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? name

        let urlString =
            "https://api.scryfall.com/cards/named?fuzzy=\(encodedName)"

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

        let result = try JSONDecoder().decode(
            ScryfallCard.self,
            from: data
        )


        // MARK: Card Identity

        let card = CardIdentity(
            name: result.name,
            game: "Magic: The Gathering",
            confidence: 1.0
        )
        
            let printing = CardPrinting(
                card: card,
                setName: result.setName,
                collectorNumber: result.collectorNumber,
                language: result.language,
                finish: result.finishes.first ?? "Unknown",
                variant: "Standard"
            )


        // MARK: Market Price

        var priceObservation: PriceObservation?

        if let usdString = result.prices.usd,
           let usdPrice = Double(usdString) {

            priceObservation = PriceObservation(
                price: usdPrice,
                currency: "USD",
                source: "Scryfall"
            )

        } else {

            priceObservation = nil
        }


        return CardLookupResult(
            card: card,
            printing: printing,
            priceObservation: priceObservation
        )
    }
}


// MARK: - Scryfall Response Models

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
