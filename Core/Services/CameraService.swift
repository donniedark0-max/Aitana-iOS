//
//  CameraService.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/10/25.
//

import AVFoundation
import SwiftUI
import Combine

@MainActor
class CameraService: ObservableObject {
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    // NUEVO: Un closure para que el ViewModel se suscriba a los fotogramas
    var onSampleBuffer: ((CMSampleBuffer) -> Void)?

    private let manager = CameraManager()
    private var isConfigured = false
    private var isRunning = false

    init() {
            manager.onPreviewLayerReady = { [weak self] layer in
                DispatchQueue.main.async {
                    self?.previewLayer = layer
                    print("📹 Preview layer ready (frame initially) = \(layer.frame)")
                }
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.2) {
                    let frame = layer.bounds
                    if frame.width > 0 && frame.height > 0 {
                        self?.manager.start()
                        self?.isRunning = true
                        print("📹 captureSession started after delay with valid layer size = \(frame)")
                    } else {
                        print("⚠️ preview layer size still zero, delaying start: \(frame)")
                    }
                }
            }

            manager.onSampleBuffer = { [weak self] buffer in
                self?.onSampleBuffer?(buffer)
            }
        }

    
    func configure() {
            guard !isConfigured else {
                print("⚙️ Camera already configured, skipping reconfiguration.")
                return
            }
            manager.configure()
            isConfigured = true
        }
    
    func start() {
        print("▶️ Starting camera service...")
        manager.start()
        isRunning = true
    }

    func stop() {
        print("⏹️ Stopping camera service...")
        manager.stop()
        isRunning = false
    }
    
    func restartIfNeeded() {
            if !isRunning {
                print("🔄 Restarting camera session after navigation return...")
                manager.start()
                isRunning = true
            }
        }

    func switchCamera() {
        manager.switchCamera()
    }
}

// MARK: - SwiftUI Preview Layer Wrapper

struct CameraPreview: UIViewRepresentable {
    let layer: AVCaptureVideoPreviewLayer
    var onReady: () -> Void

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.previewLayer = layer
        view.backgroundColor = .black
        view.onReady = onReady
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {
        uiView.setNeedsLayout()
    }

    class PreviewUIView: UIView {
        var previewLayer: AVCaptureVideoPreviewLayer!
        var onReady: (() -> Void)?
        private var hasStarted = false

        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer.frame = bounds
            if previewLayer.superlayer == nil {
                layer.addSublayer(previewLayer)
                print("📐 Added preview layer to UIView: \(bounds)")
            } else {
                previewLayer.frame = self.bounds
            }
            
            if !hasStarted && bounds.width > 0 && bounds.height > 0 {
                           onReady?()
                           hasStarted = true
                           print("✅ PreviewUIView está lista. Iniciando sesión de cámara.")
                       }
        }
    }
}
