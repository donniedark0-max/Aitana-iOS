//
//  VisionModels.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/13/25.
//

import Foundation
import CoreGraphics

// Estructura unificada para cualquier resultado de análisis de visión
struct AnalysisResult {
    var objects: [DetectedObject] = []
    var gestures: [String] = []
    var recognizedText: String = ""
}

// Modelo para un objeto detectado localmente
struct DetectedObject: Identifiable, Equatable {
    let id = UUID()
    var label: String
    var confidence: Float
    var boundingBox: CGRect
}
