//
//  LiveViewModel.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/13/25.
//

import SwiftUI
import Combine
import AVFoundation

@MainActor
class LiveViewModel: ObservableObject {
    // --- Estado de la UI ---
    @Published var isAnalyzing = false
    @Published var isListening = false
    @Published var detectedObjects: [DetectedObject] = []
    @Published var detectedGestures: [String] = []
    @Published var responseText: String?
    @Published var commandText: String? = nil 
    
    // --- Servicios y Managers ---
    private var cameraService = CameraService()
    private let webSocketManager = WebSocketManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(cameraService: CameraService) {
            self.cameraService = cameraService
            
            // Suscribirse a los fotogramas de la cámara
            self.cameraService.onSampleBuffer = { [weak self] buffer in
                self?.sendFrame(buffer)
            }
            
            // Suscribirse a las respuestas del WebSocket
            webSocketManager.responseSubject
                .receive(on: DispatchQueue.main)
                .sink { [weak self] response in
                    self?.handleBackendResponse(response)
                }
                .store(in: &cancellables)
        }
    
    func onAppear() {
            cameraService.configure()
            cameraService.restartIfNeeded() // Usamos tu lógica de reinicio que funciona
            
            if let url = URL(string: "ws://localhost/api/vision/stream/detect") {
                webSocketManager.connect(url: url)
            }
            isAnalyzing = true
        }
        
        func onDisappear() {
            cameraService.stop()
            webSocketManager.disconnect()
            isAnalyzing = false
        }
    
    private func sendFrame(_ sampleBuffer: CMSampleBuffer) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent),
              let imageData = UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.5) else { return }
        
        webSocketManager.send(frameData: imageData)
    }
    
    private func handleBackendResponse(_ response: OrchestratorResponse) {
           if let visionPayload = response.vision, !visionPayload.objects.isEmpty {
               let descriptions = visionPayload.objects.map { obj -> String in
                   var desc = obj.label
                   if let dist = obj.distanceM {
                       desc += " a \(String(format: "%.1f", dist))m"
                   }
                   return desc
               }
               self.responseText = descriptions.joined(separator: ", ")
           } else {
               self.responseText = nil
           }
       }
}
