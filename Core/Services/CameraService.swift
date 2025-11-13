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
    // NUEVO: Publicamos los colores ambientales para que la UI los observe
    @Published var ambientColors: [Color] = [.gray.opacity(0.1), .gray.opacity(0.2)]
    
    private let manager = CameraManager()
    private var isConfigured = false
    
    init() {
        manager.onPreviewLayerReady = { [weak self] layer in
            DispatchQueue.main.async {
                self?.previewLayer = layer
                print("📹 Preview layer ready (frame initially) = \(layer.frame)")
            }
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now()+0.2) {
                let frame = layer.bounds
                if frame.width > 0 && frame.height > 0 {
                    self?.manager.start()
                    print("📹 captureSession started after delay with valid layer size = \(frame)")
                } else {
                    print("⚠️ preview layer size still zero, delaying start: \(frame)")
                }
            }
        }
        
        // NUEVO: Nos suscribimos al closure de los colores
        manager.onAmbientColorsReady = { [weak self] colors in
            // Actualizamos la propiedad @Published, lo que refrescará la UI
            self?.ambientColors = colors
        }
    }
    
    func configure() {
        guard !isConfigured else { return }
        manager.configure()
        isConfigured = true
    }
    
    func start() { manager.start() }
    func stop() { manager.stop() }
    func switchCamera() { manager.switchCamera() }
}


struct CameraPreview: UIViewRepresentable {
    let layer: AVCaptureVideoPreviewLayer

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.previewLayer = layer
        view.backgroundColor = .black
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {
        uiView.setNeedsLayout()
    }

    // Sub-clase interna de UIView que ajusta el layer cuando layout ocurre
    class PreviewUIView: UIView {
        var previewLayer: AVCaptureVideoPreviewLayer!

        override func layoutSubviews() {
            super.layoutSubviews()
            guard previewLayer.superlayer != nil else {
                // Añadir la capa la primera vez
                previewLayer.frame = bounds
                layer.addSublayer(previewLayer)
                print("📐 PreviewUIView layoutSubviews: bounds = \(bounds)")
                return
            }
            // Siempre actualizar el frame de la capa
            previewLayer.frame = bounds
        }
    }
}

