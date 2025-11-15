//
//  TextRecognizer.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/14/25.
//

import Vision
import AVFoundation

class TextRecognizer {
    
    func analyze(sampleBuffer: CMSampleBuffer, completion: @escaping (String) -> Void) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            completion("")
            return
        }
        
        // Creamos la petición DENTRO de la función de análisis.
        let textRequest = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("❌ Error en el handler de OCR: \(error)")
                completion("")
                return
            }
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion("")
                return
            }
            
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            
            completion(recognizedStrings.joined(separator: "\n"))
        }
        
        // Aplicamos la configuración aquí.
        textRequest.recognitionLanguages = ["es-ES", "en-US"]
        textRequest.recognitionLevel = .accurate
        textRequest.usesLanguageCorrection = true
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            
        // Envolvemos la ejecución en un do-catch para máxima seguridad.
        do {
            try handler.perform([textRequest])
        } catch {
            print("❌ Error al ejecutar el handler de OCR: \(error)")
            completion("")
        }
    }
}
