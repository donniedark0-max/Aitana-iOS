//
//  WebSocketManager.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/13/25.
//

import Foundation
import Combine

@MainActor
class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    
    // Un "Subject" de Combine para publicar las respuestas recibidas.
    let responseSubject = PassthroughSubject<OrchestratorResponse, Never>()
    
    func connect(url: URL) {
        // Si ya hay una tarea, la desconectamos primero.
        disconnect()
        
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        print("🔗 WebSocket conectado a \(url)")
        listenForMessages()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        print("🔗 WebSocket desconectado.")
    }
    
    func send(frameData: Data) {
        guard let task = webSocketTask else { return }
        
        task.send(.data(frameData)) { error in
            if let error = error {
                print("❌ Error al enviar frame por WebSocket: \(error)")
            }
        }
    }
    
    private func listenForMessages() {
        guard let task = webSocketTask else { return }
        
        task.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("❌ Error al recibir mensaje de WebSocket: \(error)")
                // Podríamos intentar reconectar aquí.
                return
            case .success(let message):
                switch message {
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        self?.parseResponse(data)
                    }
                case .data(let data):
                    self?.parseResponse(data)
                @unknown default:
                    break
                }
                // Vuelve a escuchar el siguiente mensaje.
                self?.listenForMessages()
            }
        }
    }
    
    private func parseResponse(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(OrchestratorResponse.self, from: data)
            // Publica la respuesta decodificada.
            responseSubject.send(response)
        } catch {
            print("❌ Error al decodificar JSON de WebSocket: \(error)")
        }
    }
}
