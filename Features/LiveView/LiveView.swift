//
//  LiveView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/10/25.
//

import SwiftUI
import Combine
import Vision

struct LiveView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    @StateObject private var cameraService: CameraService
    @StateObject private var viewModel: LiveViewModel
    
    @State private var isShowingSettings = false
    @State private var isShowingDashboard = false
    
    init() {
            let service = CameraService()
            // Usamos _cameraService para inicializar el StateObject.
            _cameraService = StateObject(wrappedValue: service)
            // Creamos el ViewModel y le pasamos la instancia del CameraService.
            _viewModel = StateObject(wrappedValue: LiveViewModel(cameraService: service))
        }
    
    private var panelBubbleColors: [Color] {
            viewModel.isListening
                ? [.brandPrimary, .brandSecondary.opacity(0.8)]
                : [.brandPrimary.opacity(0.6), .brandSecondary.opacity(0.4)]
        }
    
    var body: some View {
        ZStack {
            // Capa 1 (Fondo): La cámara en vivo.
            if let previewLayer = cameraService.previewLayer {
                CameraPreview(layer: previewLayer, onReady: {})
                        .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
                    .overlay(ProgressView().tint(.white))
            }
            
            // Capa 2: Superposición para dibujar los resultados del análisis (bounding boxes)
            AnalysisOverlayView(result: viewModel.latestAnalysisResult)
                           .allowsHitTesting(false)
            
            // Capa 3: La UI principal (Header, botón de switch, y panel de control)
            VStack(spacing: 0) {
                LiveHeaderView(
                    onSettings: { isShowingSettings = true },
                    onDashboard: { coordinator.goToDashboard() }
                )

                
                HStack {
                    Spacer()
                    Button(action: { viewModel.switchCamera() }) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.title3).foregroundColor(.white).padding(8)
                            .background(.black.opacity(0.4)).clipShape(Circle())
                            .buttonStyle(.glass)

                    }
                }
                .padding(.horizontal, 20)
                
                Spacer() // Empuja el panel de control hacia abajo
                
                ControlPanelView(
                    isAnalyzing: $viewModel.isAnalyzing,
                    isListening: $viewModel.isListening,
                    analysisResult: viewModel.latestAnalysisResult,
                    bubbleColors: panelBubbleColors
                )
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .sheet(isPresented: $isShowingSettings) { SettingsView() }
        .sheet(isPresented: $isShowingDashboard) { DashboardView() }
    }
}

// MARK: - Componentes de UI

// VISTA PARA DIBUJAR LOS BOUNDING BOXES
struct AnalysisOverlayView: View {
    let result: AnalysisResult
    
    var body: some View {
        GeometryReader { geo in
            ForEach(result.objects) { obj in
                
                let rect = obj.boundingBox
                let converted = CGRect(
                    x: rect.minX * geo.size.width,
                    y: (1 - rect.maxY) * geo.size.height,
                    width: rect.width * geo.size.width,
                    height: rect.height * geo.size.height
                                )
                // BOX
                                
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.brandPrimary, lineWidth: 2)
                    .frame(width: converted.width, height: converted.height)
                    .position(
                        x: converted.midX,
                        y: converted.midY
                    )
                // LABEL
                Text("\(obj.label) \(Int(obj.confidence * 100))%")
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.brandPrimary.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .position(
                        x: converted.minX + converted.width/2,
                        y: converted.minY - 12
                    )
            }
        }
    }
}

private struct LiveHeaderView: View {
    var onSettings: () -> Void
    var onDashboard: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: onSettings) { Image(systemName: "gearshape.2") }
            Spacer()
            Text("AITANA").font(.custom("Zapfino", size: 22)).foregroundColor(.textPrimary)
            Spacer()
            Button(action: onDashboard) { Image(systemName: "square.grid.2x2") }
        }
        .font(.system(size: 20, weight: .light))
        .foregroundColor(.textMuted)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
}

private struct ControlPanelView: View {
    @Binding var isAnalyzing: Bool
    @Binding var isListening: Bool
    
    let analysisResult: AnalysisResult
    let bubbleColors: [Color]
    
    private var statusText: String {
            isListening ? "ESCUCHANDO" :
            isAnalyzing ? "ANALIZANDO" :
            "EN ESPERA"
        }
    
    private var statusColor: Color {
            isListening ? .brandPrimary :
            isAnalyzing ? .brandPrimary.opacity(0.5) :
            .textPrimary.opacity(0.4)
        }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12)
        {
            HStack(spacing: 8) {
                Circle().fill(statusColor).frame(width: 8, height: 8)
                Text(statusText).font(.geist(12, weight: .light)).tracking(2.0).foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // CONTENIDO SCROLLEABLE
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // --- OBJETOS ---
                    if !analysisResult.objects.isEmpty {
                        Text("OBJECTS:")
                            .font(.geist(10, weight: .bold))
                            .foregroundColor(.textMuted)
                        
                        Text(
                            analysisResult.objects
                                .map { $0.label }
                                .joined(separator: ", ")
                        )
                        .font(.geist(14))
                        .foregroundColor(.textPrimary)
                    }
                    
                    // --- OCR ---
                    if !analysisResult.recognizedText.isEmpty {
                        Text("OCR:")
                            .font(.geist(10, weight: .bold))
                            .foregroundColor(.textMuted)
                        
                        Text(analysisResult.recognizedText)
                            .font(.geist(14))
                            .foregroundColor(.textPrimary)
                    }
                    
                    if analysisResult.objects.isEmpty &&
                        analysisResult.recognizedText.isEmpty {
                        Text("Escuchando…")
                            .font(.geist(12))
                            .foregroundColor(.textPrimary.opacity(0.5))
                            .italic()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
        }
            
            .frame(maxWidth: .infinity)
            // --- CORRECCIÓN CLAVE DE LAYOUT ---
            .frame(height: UIScreen.main.bounds.height * 0.25) // Altura fija (25% de la pantalla)
            .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.28)
                    .background(
                        GlassBubbleView(dynamicColors: bubbleColors, opacity: isListening ? 0.35 : 0.20)
                            .background(.white.opacity(0.6))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal)
                    .padding(.bottom, 8)
        }
    }
    
    
    private struct GlassBubbleView: View {
        let dynamicColors: [Color]
        var opacity: Double
        @State private var animate = false
        
        var body: some View {
            ZStack {
                createBubble(colors: [dynamicColors[0], dynamicColors[1]], width: animate ? 420 : 320, height: animate ? 150 : 200, x: animate ? 130 : -130, y: animate ? -40 : 40, rotation: animate ? 180 : 0)
                createBubble(colors: [dynamicColors[1], (dynamicColors.count > 2 ? dynamicColors[2] : dynamicColors[0])], width: animate ? 300 : 400, height: animate ? 220 : 150, x: animate ? -130 : 130, y: animate ? 50 : -50, rotation: animate ? -180 : 0)
            }
            .blur(radius: 40)
            .opacity(opacity)
            .animation(.easeInOut(duration: 2.0), value: opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 25).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
        }
        
        
        @ViewBuilder
        private func createBubble(colors: [Color], width: CGFloat, height: CGFloat, x: CGFloat, y: CGFloat, rotation: Double) -> some View {
            Ellipse()
                .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: width, height: height)
                .rotationEffect(.degrees(rotation))
                .offset(x: x, y: y)
        }
    }


#Preview {
    RootView()
        .environmentObject(AppCoordinator())
}
