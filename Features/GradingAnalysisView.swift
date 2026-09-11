import SwiftUI
import UIKit

struct GradingAnalysisView: View {
    
    let copy: OwnedCardCopy
    
    @State private var isAnalyzing = false
    @State private var showCamera = false
    @State private var activePhoto: PhotoSlot?
    @State private var frontImage: UIImage?
    @State private var backImage: UIImage?
    @State private var showCornerInspection = false
    @State private var completedPhotos: [UIImage] = []
    
    private enum PhotoSlot {
        case front
        case back
        case none
    }
    
    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - Card
                Section("Card") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(copy.card.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(copy.printing.setName)
                            .foregroundStyle(.secondary)
                        
                        Text("#\(copy.printing.collectorNumber)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: - Photo Requirements
                Section("Card Photos") {
                    
                    gradingPhotoRow(
                        title: "Front of Card",
                        subtitle: "Required for full grading analysis",
                        icon: "rectangle.portrait"
                    )
                    
                    gradingPhotoRow(
                        title: "Back of Card",
                        subtitle: "Required for full grading analysis",
                        icon: "rectangle.portrait.fill"
                    )
                    
                }
                // MARK: - Analysis
                Section("AI Grading Analysis") {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("What TCG Radar will analyze")
                            .font(.headline)
                        
                        gradingFactor("Centering")
                        gradingFactor("Corners")
                        gradingFactor("Edges")
                        gradingFactor("Surface")
                        gradingFactor("Print defects")
                        gradingFactor("Whitening / damage")
                        gradingFactor("Alignment")
                        
                        Text(
                            "The analysis will compare the visible condition of this card against grading criteria to estimate possible PSA and CGC outcomes."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: - PSA
                Section("PSA Estimate") {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Not analyzed yet")
                            .font(.headline)
                        
                        Text(
                            "Add the required card photos and run the AI analysis to receive an estimated PSA grade probability."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
                
                // MARK: - CGC
                Section("CGC Estimate") {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Not analyzed yet")
                            .font(.headline)
                        
                        Text(
                            "Add the required card photos and run the AI analysis to receive an estimated CGC grade probability."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
                
                // MARK: - Corner Inspection

                Section {
                    NavigationLink {
                        CornerInspectionView(initialPhotos: completedPhotos) { photos in
                            completedPhotos = photos
                            print("TCG RADAR: Received \(photos.count) corner photos")
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "viewfinder")
                                .font(.title3)

                            VStack(alignment: .leading, spacing: 3) {
                                Text("Corners")
                                    .font(.headline)

                                Text(
                                    completedPhotos.count == 8
                                    ? "8 photos captured"
                                    : "8 photos • 4 front + 4 back"
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if completedPhotos.count == 8 {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            } else {
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }

                // MARK: - Analyze Button

                if completedPhotos.count == 8 {
                    Section {
                        Button {
                            runAnalysis()
                        } label: {
                            HStack {
                                Spacer()

                                if isAnalyzing {
                                    ProgressView()
                                        .tint(.white)

                                    Text("Analyzing Card...")
                                        .font(.headline)
                                } else {
                                    Image(systemName: "sparkles")

                                    Text("Analyze Card")
                                        .font(.headline)
                                }

                                Spacer()
                            }
                        }
                        .disabled(isAnalyzing)
                    }
                }
                }
            
            
        
        .sheet(isPresented: $showCamera) {
            GradingPhotoPicker(
            sourceType: .camera
        ) { image in
            if let activePhoto {
                switch activePhoto {
                case .front:
                    frontImage = image
                    
                case .back:
                    backImage = image
                    
                case .none:
                    break
                }
            }
            
            showCamera = false
            activePhoto = nil
        }                }
    }
    
    .sheet(isPresented: $showCamera) {
        // camera code
    }
}

// MARK: - Photo Row
    // MARK: - Photo Row
    private func gradingPhotoRow(
        title: String,
        subtitle: String,
        icon: String
    ) -> some View {
        
        HStack(spacing: 12) {
            
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                
                if title == "Front of Card" {
                    activePhoto = .front
                } else if title == "Back of Card" {
                    activePhoto = .back
                }
                
                showCamera = true
                
            } label: {
                
                if title == "Front of Card",
                   let image = frontImage {
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 52, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                } else if title == "Back of Card",
                          let image = backImage {
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 52, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                } else {
                    
                    Image(systemName: "plus.circle")
                        .font(.title3)
                        .foregroundStyle(.tint)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Grading Factor
    
    private func gradingFactor(_ name: String) -> some View {
        
        HStack {
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.secondary)
            
            Text(name)
            
            Spacer()
        }
    }
    
    // MARK: - Analysis
    
    private func runAnalysis() {
        
        isAnalyzing = true
        
        // The real image-analysis engine will be connected here.
        // We intentionally do not generate fake grading results.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isAnalyzing = false
        }
    }
}
