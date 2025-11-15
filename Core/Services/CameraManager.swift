//
//  CameraManager.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/11/25.
//

import AVFoundation
import SwiftUI
import CoreImage.CIFilterBuiltins


class CameraManager: NSObject {
    let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "cameraSessionQueue")
    
    var onPreviewLayerReady: ((AVCaptureVideoPreviewLayer) -> Void)?
    
    var onSampleBuffer: ((CMSampleBuffer) -> Void)?

    private var isConfigured = false
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionRuntimeError(_:)),
                                               name: .AVCaptureSessionRuntimeError,
                                               object: captureSession)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configure() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
            // Limpiar entradas/salidas
            for input in self.captureSession.inputs {
                self.captureSession.removeInput(input)
            }
            for output in self.captureSession.outputs {
                self.captureSession.removeOutput(output)
            }
            self.setupSession()
        }
    }
    
    private func setupSession() {
        guard !isConfigured else { return }
        isConfigured = true
        
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
        }
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
        
        // Elije la cámara trasera por defecto
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                        for: .video,
                                                        position: .back) else {
            print("❌ No se pudo encontrar cámara trasera.")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            
            // Limpieza entradas antiguas (ya lo hicimos arriba)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                print("❌ No se puede añadir videoInput.")
            }
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoOutputQueue"))
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            } else {
                print("❌ No se puede añadir videoOutput.")
            }
            
            if captureSession.canSetSessionPreset(.high) {
                captureSession.sessionPreset = .high
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            
            DispatchQueue.main.async { [weak self] in
                self?.onPreviewLayerReady?(previewLayer)
            }
            
        } catch {
            print("❌ Error al crear input de cámara: \(error.localizedDescription)")
        }
    }
    
    func start() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
                print("📹 captureSession started on background queue")
            }
        }
    }
    
    func stop() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
                print("📹 captureSession stopped on background queue")
            }
        }
    }
    
    func switchCamera() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
                print("📍 Stopped session before switching camera")
            }
            guard let currentInput = self.captureSession.inputs.first as? AVCaptureDeviceInput else { return }
            let newPosition: AVCaptureDevice.Position = (currentInput.device.position == .back ? .front : .back)
            guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else {
                print("❌ No device for position \(newPosition)")
                return
            }
            do {
                let newInput = try AVCaptureDeviceInput(device: newDevice)
                self.captureSession.beginConfiguration()
                self.captureSession.removeInput(currentInput)
                if self.captureSession.canAddInput(newInput) {
                    self.captureSession.addInput(newInput)
                    print("🔄 Cambió cámara a \(newPosition)")
                } else {
                    self.captureSession.addInput(currentInput)
                    print("⚠️ No se pudo cambiar, se restaura anterior")
                }
                self.captureSession.commitConfiguration()
                // Esperar pequeño delay
                Thread.sleep(forTimeInterval: 0.15)
                self.captureSession.startRunning()
                print("📍 Started session after switch camera")
            } catch {
                print("❌ Error al cambiar cámara: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func sessionRuntimeError(_ notification: Notification) {
        if let error = notification.userInfo?[AVCaptureSessionErrorKey] as? NSError {
            print("⚠️ Runtime error: \(error)")
            // Intentar reiniciar la sesión
            self.start()
        }
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Ahora sí, enviamos cada fotograma para su análisis
        onSampleBuffer?(sampleBuffer)
    }
}
