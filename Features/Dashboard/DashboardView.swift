//
//  DashboardView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/10/25.
//

import SwiftUI

// MARK: - Vista Principal del Dashboard
struct DashboardView: View {
    var body: some View {
        // Usamos un ZStack para poder poner un color de fondo global.
        ZStack {
            Color.white.ignoresSafeArea() // Fondo blanco
            
            ScrollView {
                VStack(spacing: 0) {
                    // --- Header ---
                    DashboardHeader()
                    
                    // --- Contenido Principal ---
                    VStack(spacing: 64) { // space-y-16
                        // --- Sección MIS DATOS ---
                        DashboardSection(title: "MIS DATOS") {
                            DashboardRow(label: "Perfil", value: "Configurado")
                            DashboardRow(label: "Estado", value: "Activo", valueColor: .brandAccent)
                        }
                        
                        // --- Sección ACCIONES ---
                        DashboardSection(title: "ACCIONES") {
                            DashboardActionButton(title: "VOLVER") { print("Volver presionado") }
                            DashboardActionButton(title: "CONFIGURACIÓN") { print("Configuración presionada") }
                            DashboardActionButton(title: "PREFERENCIAS") { print("Preferencias presionado") }
                            DashboardActionButton(title: "CERRAR SESIÓN") { print("Cerrar Sesión presionado") }
                        }
                    }
                    .padding(.horizontal, 24) // px-6
                    .padding(.vertical, 48)   // py-12
                    
                    // --- Footer ---
                    DashboardFooter()
                }
            }
        }
    }
}

// MARK: - Componentes Reutilizables de la Vista

private struct DashboardHeader: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("BIENVENIDO")
                    .font(.geist(12, weight: .bold))
                    .tracking(2.0) // tracking-widest
                Text("素晴らしい") // "Subarashī" - Maravilloso
                    .font(.system(size: 12))
                    .foregroundColor(.textMuted)
            }
            
            Spacer()
            
            // Círculo de perfil anidado
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.20))
                    .frame(width: 32, height: 32)
            }
            .frame(width: 40, height: 40)
            .background(Circle().fill(Color.brandPrimary.opacity(0.10)))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .background(
            // Borde inferior
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.borderDefault)
                .opacity(0.3)
                .frame(maxHeight: .infinity, alignment: .bottom)
        )
    }
}

private struct DashboardSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) { // space-y-6
            Rectangle()
                .fill(Color.borderDefault)
                .opacity(0.3)
                .frame(width: 48, height: 1) // w-12
            
            Text(title)
                .font(.geist(14, weight: .light))
                .tracking(1.0) // tracking-wide
            
            content
        }
    }
}

private struct DashboardRow: View {
    let label: String
    let value: String
    var valueColor: Color = .textPrimary
    
    var body: some View {
        HStack {
            Text(label)
                .font(.geist(12))
                .foregroundColor(.textMuted)
            Spacer()
            Text(value)
                .font(.geist(12))
                .foregroundColor(valueColor)
        }
        .padding(.vertical, 12) // py-3
        .background(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.borderDefault.opacity(0.3))
                .frame(maxHeight: .infinity, alignment: .bottom)
        )
    }
}

private struct DashboardActionButton: View {
    let title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("↳ \(title)")
                    .font(.geist(12))
                Spacer()
            }
            .padding(.vertical, 6) // py-3 (ajustado para mejor sensación táctil)
        }
        .foregroundColor(.textPrimary)
    }
}

private struct DashboardFooter: View {
    var body: some View {
        VStack(spacing: 8) { // space-y-2
            Rectangle()
                .fill(Color.brandAccent)
                .frame(width: 4, height: 24) // w-1 h-6 (ajustado para mejor visibilidad)
            
            Text("素晴らしい世界") // "Subarashī sekai" - Mundo Maravilloso
                .font(.system(size: 12))
                .foregroundColor(.textMuted)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 48)
    }
}


// MARK: - Vista Previa
#Preview {
    DashboardView()
}
