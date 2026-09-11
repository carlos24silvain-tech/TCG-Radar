import Foundation
import UIKit

enum GradingEngineError: LocalizedError {
    case missingFrontImage
    case missingBackImage
    case notConfigured
    case invalidResponse
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .missingFrontImage:
            return "A front photo of the card is required."
        case .missingBackImage:
            return "A back photo of the card is required."
        case .notConfigured:
            return "The grading analysis service is not connected yet."
        case .invalidResponse:
            return "The grading service returned an invalid response."
        case .networkError(let message):
            return message
        }
    }
}

struct GradingEngine {

    // MARK: - Configuration

    /*
     The grading engine will eventually send the card photos
     to TCG Radar's secure analysis server.

     IMPORTANT:
     We will NOT put an OpenAI, PSA, CGC, or other private API
     key inside the iPhone app.
    */

    private let analysisURL: URL?

    init() {
        analysisURL = nil
    }

    // MARK: - Analyze Card

    func analyze(
        frontImage: UIImage?,
        backImage: UIImage?,
        cornerImages: [UIImage],
        card: CardIdentity
    ) async throws -> GradingAssessment {

        guard frontImage != nil else {
            throw GradingEngineError.missingFrontImage
        }

        guard backImage != nil else {
            throw GradingEngineError.missingBackImage
        }

        guard cornerImages.count == 8 else {
            throw GradingEngineError.networkError(
                "All 8 corner inspection photos are required."
            )
        }

        guard analysisURL != nil else {
            throw GradingEngineError.notConfigured
        }

        // The secure vision-analysis connection will be added here.
        //
        // The server will analyze:
        // • Centering
        // • Corners
        // • Edges
        // • Surface
        // • Print defects
        // • Whitening / damage
        // • Alignment
        // • Authenticity risk
        // • PSA estimate
        // • CGC estimate
        //
        // We intentionally do not generate fake grades.

        throw GradingEngineError.notConfigured
    }
}
