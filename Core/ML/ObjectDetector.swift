//
//  ObjectDetector.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/14/25.
//

import Vision
import CoreML
import AVFoundation

class ObjectDetector {
    private var model: VNCoreMLModel
    
    init() {
        do {
            // Xcode genera automáticamente una clase para el modelo
            let coreMLModel = try yolov11s(configuration: MLModelConfiguration()).model
            self.model = try VNCoreMLModel(for: coreMLModel)
        } catch {
            fatalError("FATAL ERROR: No se pudo cargar el modelo Core ML de YOLO. Error: \(error)")
        }
    }
    
    func analyze(sampleBuffer: CMSampleBuffer,
                     completion: @escaping ([DetectedObject]) -> Void) {
            
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                completion([])
                return
            }
            
            let request = VNCoreMLRequest(model: model) { req, err in
                if let err = err {
                    print("❌ Error en YOLO: \(err)")
                    completion([])
                    return
                }
                
                guard let observations = req.results as? [VNRecognizedObjectObservation] else {
                    completion([])
                    return
                }
                
                let objects = observations.map { obs in
                    DetectedObject(
                        label: obs.labels.first?.identifier ?? "objeto",
                        confidence: obs.labels.first?.confidence ?? 0,
                        boundingBox: obs.boundingBox // NORMALIZADO 0–1
                    )
                }
                
                completion(objects)
            }
            
            request.imageCropAndScaleOption = .scaleFill
            
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            do {
                try handler.perform([request])
            } catch {
                print("❌ Error al ejecutar YOLO: \(error)")
                completion([])
            }
        }
    }
}
