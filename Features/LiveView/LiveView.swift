//
//  LiveView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/10/25.
//

import SwiftUI

struct LiveView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var cameraService = CameraService()
    
    
    @State private var isAnalyzing = true
    @State private var isListening = false
    
    @State private var isShowingSettings = false
    
    var body: some View {
        ZStack {
            // Fondo negro fijo. Esto da estabilidad al layout.
            Color.black.ignoresSafeArea()
            
            // Capa de la cámara
            if let previewLayer = cameraService.previewLayer {
                           CameraPreview(layer: previewLayer)
                               .mask(RoundedRectangle(cornerRadius: 12))
                               .aspectRatio(9/16, contentMode: .fit)
                               .frame(height: UIScreen.main.bounds.height * 0.5)
                               .padding(.horizontal, 16)
                       } else {
                           RoundedRectangle(cornerRadius: 12)
                               .fill(Color.black.opacity(0.8))
                               .aspectRatio(9/16, contentMode: .fit)
                               .frame(height: UIScreen.main.bounds.height * 0.5)
                               .padding(.horizontal, 16)
                               .overlay(ProgressView().tint(.white))
                       }
            
            // Capa de la UI
            VStack(spacing: 0) {
                LiveHeaderView(
                    onSettings: { isShowingSettings = true },
                    onDashboard: { coordinator.goToDashboard() }
                )
                Spacer()
                ControlPanelView(isAnalyzing: $isAnalyzing, isListening: $isListening, command: .constant(nil), response: .constant(nil))
            }
            
            // Capa de controles sobre el video
            CameraViewContainer(isAnalyzing: $isAnalyzing) {
                cameraService.switchCamera()
            }
        }
        .onAppear {
            cameraService.configure()
        }
        .onDisappear {
            cameraService.stop()
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
        .padding(.top, 5)
        .padding(.bottom, 12)
        .background(Color(white: 0.95).opacity(0.8)) // Fondo claro semitransparente
    }
}

private struct CameraViewContainer: View {
    @Binding var isAnalyzing: Bool
    var onSwitchCamera: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack(alignment: .topTrailing) {
                // Borde transparente, solo para definir el área
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isAnalyzing ? Color.brandPrimary : Color.brandPrimary.opacity(0.4), lineWidth: 2)
                
                Button(action: onSwitchCamera) {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .font(.title3).foregroundColor(.white).padding(8)
                        .background(.black.opacity(0.4)).clipShape(Circle())
                }
                .padding(8)
            }
            .aspectRatio(9/16, contentMode: .fit)
            .frame(height: UIScreen.main.bounds.height * 0.5)
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
}

private struct ControlPanelView: View {
    @Binding var isAnalyzing: Bool
    @Binding var isListening: Bool
    @Binding var command: String?
    @Binding var response: String?
    
    private var statusText: String {
        if isListening { return "E S C U C H A N D O" }
        if isAnalyzing { return "A N A L I Z A N D O" }
        return "E N   E S P E R A"
    }
    
    private var statusColor: Color {
        if isListening { return .brandPrimary }
        if isAnalyzing { return .brandPrimary.opacity(0.5) }
        return .textMuted.opacity(0.4)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Circle().fill(statusColor).frame(width: 8, height: 8)
                Text(statusText).font(.geist(12, weight: .light)).tracking(2.0).foregroundColor(.textMuted)
            }
            if command == nil && response == nil {
                Text("Escuchando...").font(.geist(12)).foregroundColor(.textMuted.opacity(0.6)).italic()
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 48)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(white: 0.95).opacity(0.8)) // Fondo claro semitransparente
    }
}

#Preview {
    RootView()
        .environmentObject(AppCoordinator())
}
