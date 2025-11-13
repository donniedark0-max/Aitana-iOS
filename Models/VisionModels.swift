//
//  VisionModels.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/13/25.
//

import Foundation

// Corresponde a la respuesta completa del orquestador
struct OrchestratorResponse: Codable {
    let vision: VisionPayload?
    let gestures: GesturePayload?
}

// Corresponde al objeto "vision"
struct VisionPayload: Codable {
    let objects: [DetectedObject]
}

// Corresponde al objeto "gestures"
struct GesturePayload: Codable {
    let gestures: [String]
}

// Corresponde a cada objeto detectado por YOLO
struct DetectedObject: Codable, Identifiable {
    let id = UUID() // Para usar en listas de SwiftUI
    let label: String
    let confidence: Double
    let box: [Int]
    let distanceM: Double?
    let dominantColorHex: String?

    enum CodingKeys: String, CodingKey {
        case label, confidence, box
        case distanceM = "distance_m"
        case dominantColorHex = "dominant_color_hex"
    }
}
