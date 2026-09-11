//
//  CameraScannerView 2.swift
//  TCG Radar
//
//  Created by carlos silvain on 9/9/26.
//


import SwiftUI
import AVFoundation
import Vision

struct CameraScannerView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.startCamera()
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewView, context: Context) {
    }
}

final class CameraPreviewView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let videoOutput = AVCaptureVideoDataOutput()
    
    private var lastScanTime = Date.distantPast
    private let scanInterval: TimeInterval = 0.7
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
    
    func startCamera() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            setupCamera()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                }
            }
            
        default:
            break
        }
    }
    
    private func setupCamera() {
        
        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            videoOutput.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as String:
                    kCVPixelFormatType_32BGRA
            ]
            
            videoOutput.alwaysDiscardsLateVideoFrames = true
            
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            videoOutput.setSampleBufferDelegate(
                self,
                queue: DispatchQueue(
                    label: "TCGRadar.CameraQueue"
                )
            )
            
            let preview = AVCaptureVideoPreviewLayer(
                session: captureSession
            )
            
            preview.videoGravity = .resizeAspectFill
            
            layer.insertSublayer(preview, at: 0)
            previewLayer = preview
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
            
        } catch {
            print("Camera setup error: \(error)")
        }
    }
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        
        let now = Date()
        
        guard now.timeIntervalSince(lastScanTime) >= scanInterval else {
            return
        }
        
        lastScanTime = now
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            
            if let error = error {
                print("Text recognition error: \(error)")
                return
            }
            
            guard let observations = request.results as? [
                VNRecognizedTextObservation
            ] else {
                return
            }
            
            let recognizedText = observations.compactMap {
                $0.topCandidates(1).first?.string
            }
            
            if !recognizedText.isEmpty {
                print("TCG RADAR READ:")
                print(recognizedText.joined(separator: " | "))
            }
        }
        
        request.recognitionLevel = .fast
        request.usesLanguageCorrection = true
        
        let handler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            orientation: .right,
            options: [:]
        )
        
        do {
            try handler.perform([request])
        } catch {
            print("Vision error: \(error)")
        }
    }
}