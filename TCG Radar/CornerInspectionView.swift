import SwiftUI
import UIKit

struct CornerInspectionView: View {

    let onComplete: ([UIImage]) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var photos: [UIImage?]

    init(initialPhotos: [UIImage] = [], onComplete: @escaping ([UIImage]) -> Void) {
        self.onComplete = onComplete

        var startingPhotos: [UIImage?] = Array(repeating: nil, count: 8)

        for index in 0..<min(initialPhotos.count, 8) {
            startingPhotos[index] = initialPhotos[index]
        }

        _photos = State(initialValue: startingPhotos)
    }

    @State private var selectedCorner: Int?
    @State private var showCamera = false

    private let positions = [
        "Front • Top Left",
        "Front • Top Right",
        "Front • Bottom Left",
        "Front • Bottom Right",
        "Back • Top Left",
        "Back • Top Right",
        "Back • Bottom Left",
        "Back • Bottom Right"
    ]

    var body: some View {
        NavigationStack {
            List {

                Section("Corner Photos") {

                    ForEach(Array(0..<8), id: \.self) { index in

                        Button {
                            selectedCorner = index
                            showCamera = true
                        } label: {

                            HStack(spacing: 14) {

                                // Preview
                                if let image = photos[index] {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 10)
                                        )
                                } else {
                                    Image(systemName: "camera.fill")
                                        .font(.title3)
                                        .foregroundStyle(.orange)
                                        .frame(width: 60, height: 60)
                                        .background(
                                            Color.orange.opacity(0.12)
                                        )
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 10)
                                        )
                                }

                                VStack(alignment: .leading, spacing: 4) {

                                    Text(positions[index])
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    Text(
                                        photos[index] == nil
                                        ? "Tap to capture"
                                        : "Photo captured • Tap to retake"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }

                                Spacer()

                                if photos[index] == nil {
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }

                Section {
                    Button {
                        let completedPhotos = photos.compactMap { $0 }
                        onComplete(completedPhotos)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()

                            Text(
                                completedCount == 8
                                ? "Continue to Grading Analysis"
                                : "\(completedCount) of 8 Captured"
                            )
                            .font(.headline)

                            Spacer()
                        }
                    }
                    .disabled(completedCount != 8)
                }
            }
            .navigationTitle("Corner Inspection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .sheet(isPresented: $showCamera) {

                CornerCameraView { image in

                    if let index = selectedCorner {
                        photos[index] = image
                    }

                    showCamera = false
                    selectedCorner = nil
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var completedCount: Int {
        photos.compactMap { $0 }.count
    }
}


// MARK: - Camera

struct CornerCameraView: UIViewControllerRepresentable {

    let onCapture: (UIImage) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onCapture: onCapture)
    }

    func makeUIViewController(
        context: Context
    ) -> UIImagePickerController {

        let picker = UIImagePickerController()

        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        picker.allowsEditing = false

        return picker
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {
    }

    final class Coordinator: NSObject,
                       UINavigationControllerDelegate,
                       UIImagePickerControllerDelegate {

        let onCapture: (UIImage) -> Void

        init(onCapture: @escaping (UIImage) -> Void) {
            self.onCapture = onCapture
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info:
                [UIImagePickerController.InfoKey: Any]
        ) {

            if let image = info[
                .originalImage
            ] as? UIImage {

                onCapture(image)
            }

            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(
            _ picker: UIImagePickerController
        ) {
            picker.dismiss(animated: true)
        }
    }
}
