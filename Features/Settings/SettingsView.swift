//
//  SettingsView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/10/25.
//

import SwiftUI

// MARK: - Vista Principal de Ajustes
struct SettingsView: View {
    // Para poder cerrar la vista modal
    @Environment(\.dismiss) var dismiss
    
    // Estados para los controles
    @State private var notifications = true
    @State private var darkMode = false
    @State private var selectedLanguage = "Español"
    let languages = ["Español", "English (UK)", "Français (FR)"]

    var body: some View {
        VStack(spacing: 0) {
            // --- Header ---
            SettingsHeader(onClose: { dismiss() })
            
            Spacer()
            
            // --- Contenido Principal ---
            VStack(spacing: 32) { // space-y-8
                // Línea de acento vertical
                Rectangle()
                    .fill(Color.borderDefault.opacity(0.5))
                    .frame(width: 1, height: 32)
                
                // Opciones
                VStack(spacing: 24) { // space-y-6
                    Toggle("Notificaciones", isOn: $notifications)
                    Toggle("Modo Oscuro", isOn: $darkMode)
                    
                    // Selector de Idioma
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Idioma")
                        Picker("Idioma", selection: $selectedLanguage) {
                            ForEach(languages, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu) // Estilo desplegable
                        .accentColor(.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, -4) // Ajuste para alinear con el texto
                    }
                }
                .font(.geist(14))
                .tracking(0.5)
                .tint(.brandPrimary) // Colorea los Toggles
                
                // Línea de acento vertical
                Rectangle()
                    .fill(Color.borderDefault.opacity(0.5))
                    .frame(width: 1, height: 32)
                    .padding(.vertical, 24)
                
                // Botón Cerrar
                GradientButton(title: "Cerrar") {
                    dismiss()
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(Color.white)
    }
}

// MARK: - Componentes de la Vista

private struct SettingsHeader: View {
    var onClose: () -> Void
    
    var body: some View {
        HStack {
            // Spacer invisible para centrar el título
            Color.clear.frame(width: 24, height: 24)
            
            Spacer()
            
            Text("A J U S T E S")
                .font(.geist(12, weight: .light))
                .tracking(3.0)
            
            Spacer()
            
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .regular))
            }
        }
        .foregroundColor(.textMuted)
        .padding(16)
        .background(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.borderDefault.opacity(0.5))
                .frame(maxHeight: .infinity, alignment: .bottom)
        )
    }
}

// MARK: - Vista Previa
#Preview {
    SettingsView()
}
