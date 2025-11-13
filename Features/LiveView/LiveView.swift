//
//  LiveView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/10/25.
//

import SwiftUI
import Combine

struct LiveView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var cameraService = CameraService()
    
    @State private var cameraOpacity: Double = 0.0

    
    @State private var isAnalyzing = false
    @State private var isListening = true
    
    @State private var isShowingSettings = false
    
    private var panelBubbleColors: [Color] {
        if isListening {
            return [.brandPrimary, .brandSecondary.opacity(0.8)]
        } else {
            return [.brandPrimary.opacity(0.6), .brandSecondary.opacity(0.4)]
        }
    }
    
    var body: some View {
        ZStack {
            // Capa 1 (Fondo): La cámara en vivo.
            if let previewLayer = cameraService.previewLayer {
                CameraPreview(layer: previewLayer)
                    .ignoresSafeArea()
                    .opacity(cameraOpacity)
            } else {
                Color.black.ignoresSafeArea()
                    .overlay(ProgressView().tint(.white))
                    .opacity(cameraOpacity)
            }
            
            // Capa 2: La UI principal.
            VStack(spacing: 0) {
                LiveHeaderView(
                    onSettings: { isShowingSettings = true },
                    onDashboard: { coordinator.goToDashboard() }
                )
                
                HStack {
                    Spacer()
                    Button(action: { cameraService.switchCamera() }) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.title3).foregroundColor(.white).padding(8)
                            .background(.black.opacity(0.4)).clipShape(Circle())
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                ControlPanelView(
                    isAnalyzing: $isAnalyzing,
                    isListening: $isListening,
                    command: .constant(nil),
                    response: .constant(nil),
                    bubbleColors: panelBubbleColors // Pasamos los colores al panel
                )
            }
        }
        .onAppear {
            cameraService.configure()
            cameraService.restartIfNeeded()
            withAnimation(.easeIn(duration: 0.5)) {
                        cameraOpacity = 1.0
                    }
        }
        .onDisappear {
            cameraService.stop()
            cameraOpacity = 0.0
        }
        .sheet(isPresented: $isShowingSettings) { SettingsView() }
    }
}

// MARK: - Componentes de UI

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
        .background(
            .ultraThinMaterial)
            
        
    }
}

private struct ControlPanelView: View {
    @Binding var isAnalyzing: Bool
    @Binding var isListening: Bool
    @Binding var command: String?
    @Binding var response: String?
    let bubbleColors: [Color] // Recibe los colores para la burbuja
    
    private var statusText: String {
        if isListening { return "E S C U C H A N D O" }
        if isAnalyzing { return "A N A L I Z A N D O" }
        return "E N   E S P E R A"
    }
    
    private var statusColor: Color {
        if isListening { return .brandPrimary }
        if isAnalyzing { return .brandPrimary.opacity(0.5) }
        return .textPrimary.opacity(0.4)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Circle().fill(statusColor).frame(width: 8, height: 8)
                Text(statusText).font(.geist(12, weight: .light)).tracking(2.0).foregroundColor(.textPrimary)
            }
            if command == nil && response == nil {
                Text("Escuchando...").font(.geist(12)).foregroundColor(.textPrimary.opacity(0.6)).italic()
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 48)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
                    // CORREGIDO: La burbuja ahora está contenida y es el fondo de este panel
            ZStack {
                  Color.white
              
                        
                        // Burbuja contenida
                        GlassBubbleView(
                            dynamicColors: bubbleColors,
                            opacity: isListening ? 0.35 : 0.20 // Opacidad más sutil
                        )
                        .clipped() // <-- ESTA ES LA CLAVE PARA CONTENER LA BURBUJA
                    }
        )
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
        .blur(radius: 40) // Menos blur para que sea más sutil
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
