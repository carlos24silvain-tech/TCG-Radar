import Foundation

enum GradingCompany: String, Codable, CaseIterable {
    case psa = "PSA"
    case cgc = "CGC"
}

enum GradingStatus: String, Codable {
    case raw
    case analyzing
    case preparing
    case submitted
    case received
    case grading
    case graded
    case returned
}

struct GradeEstimate: Identifiable, Codable {
    
    let id: UUID
    let company: GradingCompany
    
    // The grade the AI considers most likely.
    let estimatedGrade: Double
    
    // Grade -> probability
    // Example: 10.0 -> 0.18 means an estimated 18% chance.
    let probabilities: [Double: Double]
    
    // Confidence in the analysis itself,
    // NOT confidence that the grading company will award the grade.
    let confidence: Double
    
    let analyzedAt: Date
}

struct GradingAssessment: Identifiable, Codable {
    
    let id: UUID
    
    // Images used for the assessment.
    let frontImagePath: String?
    let backImagePath: String?
    
    // Optional detailed inspection images.
    let cornerImagePaths: [String]
    let edgeImagePaths: [String]
    let surfaceImagePaths: [String]
    
    // AI condition analysis.
    let centeringScore: Double?
    let cornerScore: Double?
    let edgeScore: Double?
    let surfaceScore: Double?
    let printDefectScore: Double?
    
    // This is a warning indicator, not a declaration
    // that a card is counterfeit.
    let authenticityRisk: Double?
    
    let psa: GradeEstimate?
    let cgc: GradeEstimate?
    
    let analyzedAt: Date
}

struct GradingSubmission: Identifiable, Codable {
    
    let id: UUID
    
    let company: GradingCompany
    
    var submissionNumber: String?
    var serviceLevel: String?
    var declaredValue: Double?
    
    var submittedAt: Date?
    var status: GradingStatus
    
    var certNumber: String?
    var finalGrade: Double?
}
