//
//  ContentView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/7/25.
//

import SwiftUI

struct LoginView: View {
    var onLoginSuccess: () -> Void
    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // --- MITAD SUPERIOR: LOGO ---
                VStack {
                    Spacer()
                    LogoView() // Usamos la vista del logo
                }
                .frame(minHeight: UIScreen.main.bounds.height / 2.2)

                // --- MITAD INFERIOR: FORMULARIO ---
                VStack(spacing: 32) {
                    UnderlinedTextField(
                        title: "USUARIO",
                        placeholder: "Introduce tu nombre de usuario",
                        text: $username
                    )

                    UnderlinedSecureField(
                        title: "CONTRASEÑA",
                        placeholder: "Introduce tu contraseña",
                        text: $password
                    )

                    Spacer().frame(height: 24)

                    // --- BOTÓN ANIMADO ---
                    AnimatedGradientButton(title: isLoading ? "INICIANDO..." : "INICIAR SESIÓN") {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                            onLoginSuccess()
                        }
                    }
                    .disabled(isLoading)
                    .opacity(isLoading ? 0.5 : 1.0)

                    // Botón Secundario
                    Button(action: {}) {
                        Text("REGISTRARSE AHORA")
                            .font(.geist(14, weight: .bold))
                            .tracking(1.1)
                            .foregroundColor(Color.brandPrimary) // Usando color centralizado
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                    }
                }
                .padding(.top, 64)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.white)
        .ignoresSafeArea()
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// --- Componente Reutilizable para el Logo (usando colores centralizados) ---
struct LogoView: View {
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.brandAccent)
                .frame(width: 8, height: 8)
                .padding(.bottom, 16)

            VStack(spacing: 4) {
                Text("AITANA")
                    .font(.geist(36, weight: .bold))
                    .tracking(-1)
                    .foregroundColor(Color.textPrimary)

                Text("2.0")
                    .font(.system(size: 12, weight: .light))
                    .tracking(2.5)
                    .foregroundColor(Color.textMuted)
            }

            VStack(spacing: 4) {
                Rectangle().fill(Color.brandAccent).frame(width: 32, height: 1)
                Rectangle().fill(Color.borderDefault).frame(width: 48, height: 1)
                Rectangle().fill(Color.brandAccent.opacity(0.5)).frame(width: 8, height: 1)
                    .padding(.top, 4)
            }
            .padding(.top, 24)
        }
    }
}

// --- Componentes de Campos de Texto (simplificados) ---
struct UnderlinedTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.geist(12, weight: .bold))
                .tracking(2.0)
                .foregroundColor(Color.textPrimary)
            
            TextField(placeholder, text: $text)
                .font(.geist(14))
                .foregroundColor(Color.textMuted)
                .focused($isFocused)
                .padding(.bottom, 8)
                .background(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(isFocused ? Color.brandPrimary : Color.borderDefault)
                        .padding(.top, 28)
                )
        }
    }
}

struct UnderlinedSecureField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.geist(12, weight: .bold))
                .tracking(2.0)
                .foregroundColor(Color.textPrimary)
            
            SecureField(placeholder, text: $text)
                .font(.geist(14))
                .foregroundColor(Color.textMuted)
                .focused($isFocused)
                .padding(.bottom, 8)
                .background(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(isFocused ? Color.brandPrimary : Color.borderDefault)
                        .padding(.top, 28)
                )
        }
    }
}

#Preview {
    LoginView(onLoginSuccess: {
        print("Login exitoso en la vista previa.")
    })
}
