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
    @Published var latestAnalysisResult = AnalysisResult()
    
    private var cameraService: CameraService
    
    // --- Analizadores de IA On-Device ---
    private let objectDetector = ObjectDetector()
    private let textRecognizer = TextRecognizer()
    
    private let frameSubject = PassthroughSubject<CMSampleBuffer, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(cameraService: CameraService) {
        self.cameraService = cameraService
        self.cameraService.onSampleBuffer = { [weak self] buffer in
            self?.analyzeFrame(buffer)
        }
        
    }
    
    func onAppear() {
        isAnalyzing = true
        cameraService.configure()
        cameraService.restartIfNeeded()
    }
    
    func onDisappear() {
        isAnalyzing = false
        cameraService.stop()
    }
    
    func switchCamera() {
        cameraService.switchCamera()
    }
    
    private func analyzeFrame(_ sampleBuffer: CMSampleBuffer) {
        Task {
            async let objectResults = self.runObjectDetection(on: sampleBuffer)
            async let textResults = self.runTextRecognition(on: sampleBuffer)
            
            // Esperamos a que ambos terminen
            let (objects, text) = await (objectResults, textResults)
            
            // Actualizamos la UI una sola vez en el hilo principal
            DispatchQueue.main.async {
                self.latestAnalysisResult.objects = objects
                self.latestAnalysisResult.recognizedText = text
            }
        }
    }

    
    // Funciones helper asíncronas para cada analizador
        private func runObjectDetection(on buffer: CMSampleBuffer) async -> [DetectedObject] {
            
            return await withCheckedContinuation { continuation in
                objectDetector.analyze(sampleBuffer: buffer) { results in
                    continuation.resume(returning: results)
                }
            }
        }
        
        private func runTextRecognition(on buffer: CMSampleBuffer) async -> String {
            return await withCheckedContinuation { continuation in
                textRecognizer.analyze(sampleBuffer: buffer) { result in
                    continuation.resume(returning: result)
                }
            }
        }
    }
