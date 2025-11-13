//
//  DashboardView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/10/25.
//

import SwiftUI

// MARK: - Vista Principal del Dashboard
struct DashboardView: View {
    // Inyectamos el coordinador para poder llamar a sus funciones
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    DashboardHeader()
                    
                    VStack(spacing: 64) {
                        DashboardSection(title: "MIS DATOS") {
                            DashboardRow(label: "Perfil", value: "Configurado")
                            DashboardRow(label: "Estado", value: "Activo", valueColor: .brandAccent)
                        }
                        
                        // --- Sección ACCIONES (CORREGIDA) ---
                        DashboardSection(title: "ACCIONES") {
                            // Ahora los botones llaman a las funciones del coordinador
                            DashboardActionButton(title: "VOLVER") { coordinator.goBack() }
                            DashboardActionButton(title: "CONFIGURACIÓN") { coordinator.showSettings() }
                            DashboardActionButton(title: "PREFERENCIAS") { /* Lógica futura */ }
                            DashboardActionButton(title: "CERRAR SESIÓN") { coordinator.logout() }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 48)
                    
                    DashboardFooter()
                }
            }
        }
        // Añadimos un título a la barra de navegación para cuando se navega a esta vista
        .navigationTitle("Dashboard")
        .navigationBarHidden(true) // Ocultamos la barra de navegación estándar para usar nuestro header personalizado
    }
}

// MARK: - Componentes Reutilizables de la Vista (sin cambios)

private struct DashboardHeader: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("BIENVENIDO").font(.geist(12, weight: .bold)).tracking(2.0)
                Text("素晴らしい").font(.system(size: 12)).foregroundColor(.textMuted)
            }
            Spacer()
            ZStack {
                Circle().fill(Color.brandPrimary.opacity(0.20)).frame(width: 32, height: 32)
            }
            .frame(width: 40, height: 40)
            .background(Circle().fill(Color.brandPrimary.opacity(0.10)))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .background(
            Rectangle().frame(height: 1).foregroundColor(.borderDefault)
                .frame(maxHeight: .infinity, alignment: .bottom)
        )
    }
}

private struct DashboardSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Rectangle().fill(Color.borderDefault).frame(width: 48, height: 1)
            Text(title).font(.geist(14, weight: .light)).tracking(1.0)
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
            Text(label).font(.geist(12)).foregroundColor(.textMuted)
            Spacer()
            Text(value).font(.geist(12)).foregroundColor(valueColor)
        }
        .padding(.vertical, 12)
        .background(
            Rectangle().frame(height: 1).foregroundColor(.borderDefault.opacity(0.5))
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
                Text("↳ \(title)").font(.geist(12))
                Spacer()
            }
            .padding(.vertical, 6)
        }
        .foregroundColor(.textPrimary)
    }
}

private struct DashboardFooter: View {
    var body: some View {
        VStack(spacing: 8) {
            Rectangle().fill(Color.brandAccent).frame(width: 4, height: 24)
            Text("素晴らしい世界").font(.system(size: 12)).foregroundColor(.textMuted)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 48)
    }
}

// MARK: - Vista Previa
#Preview {
    // La vista previa también necesita el coordinador para funcionar
    DashboardView()
        .environmentObject(AppCoordinator())
}
