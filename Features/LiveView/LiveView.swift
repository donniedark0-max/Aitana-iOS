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
    
    @StateObject private var cameraService: CameraService
    @StateObject private var viewModel: LiveViewModel
    
    @State private var isShowingSettings = false
    @State private var isShowingDashboard = false


    // El inicializador que conecta todo.
    init() {
        let service = CameraService()
        _cameraService = StateObject(wrappedValue: service)
        _viewModel = StateObject(wrappedValue: LiveViewModel(cameraService: service))
    }
    
    private var panelBubbleColors: [Color] {
        if viewModel.isListening {
            return [.brandPrimary, .brandSecondary.opacity(0.8)]
        } else {
            return [.brandPrimary.opacity(0.6), .brandSecondary.opacity(0.4)]
        }
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
            
            // Capa 2: La UI principal.
            VStack(spacing: 0) {
                LiveHeaderView(
                    onSettings: { isShowingSettings = true },
                    onDashboard: { coordinator.goToDashboard() }
                )
                
                // Botón de cambio de cámara, ahora en el header para no estar sobre el video.
                HStack {
                    Spacer()
                    Button(action: { cameraService.switchCamera() }) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.title3).foregroundColor(.textPrimary).padding(8)
                            .background(.black.opacity(0.4)).clipShape(Circle())
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                ControlPanelView(
                    isAnalyzing: $viewModel.isAnalyzing,
                    isListening: $viewModel.isListening,
                    command: $viewModel.commandText,
                    response: $viewModel.responseText,
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
        .sheet(isPresented: $isShowingDashboard) { DashboardView()}
            
        
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
    @Binding var command: String?
    @Binding var response: String?
    let bubbleColors: [Color]
    
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
            if let responseText = response {
                Text(responseText).font(.geist(14))
            } else if command == nil {
                Text("Escuchando...").font(.geist(12)).foregroundColor(.textPrimary.opacity(0.6)).italic()
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 48)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                Color.white
                GlassBubbleView(
                    dynamicColors: bubbleColors,
                    opacity: isListening ? 0.35 : 0.20
                )
                .clipped()
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
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

