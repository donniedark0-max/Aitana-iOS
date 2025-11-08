//
//  SettingsStepView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/8/25.
//

import SwiftUI

struct SettingsStepView: View {
    @State private var notifications = false
    @State private var darkMode = false
    @State private var autoAnalysis = true
    
    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Text("Preferencias")
                    .font(.geist(22, weight: .light))
                    .tracking(-0.5)
                    .padding(.bottom, 16)
                Rectangle()
                    .fill(Color.brandPrimary)
                    .frame(width: 32, height: 1)
            }
            
            VStack(spacing: 24) {
                Toggle("Notificaciones", isOn: $notifications)
                Toggle("Modo Oscuro", isOn: $darkMode)
                Toggle("Análisis Automático", isOn: $autoAnalysis)
            }
            .font(.geist(14))
            .tint(Color.brandPrimary) // Colorea los Toggles
        }
    }
}
