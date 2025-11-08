//
//  OnboardingView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/8/25.
//

import SwiftUI

// Enum para gestionar los pasos de forma segura
enum OnboardingStep {
    case welcome, personalInfo, profilePhoto, settings
}

// MARK: - Vista Principal del Onboarding
struct OnboardingView: View {
    var onComplete: () -> Void // Propiedad para el closure que notifica la finalización
    
    @State private var step: OnboardingStep = .welcome
    
    // Estado para los datos del formulario
    @State private var name: String = ""
    @State private var email: String = ""
    
    // Array para controlar la navegación
    private let steps: [OnboardingStep] = [.welcome, .personalInfo, .profilePhoto, .settings]
    
    var body: some View {
            // Usamos GeometryReader para obtener el tamaño del espacio disponible de forma segura.
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // --- Header ---
                    OnboardingHeaderView()
                    
                    // --- Contenido Principal ---
                    ZStack {
                        // Línea guía vertical decorativa
                        Rectangle()
                            .fill(Color.brandPrimary.opacity(0.05))
                            .frame(width: 1)
                            // CORRECCIÓN: Usamos `geometry.size.width` en lugar de `UIScreen.main.bounds.width`
                            .offset(x: -geometry.size.width / 2 + 48)
                        
                        VStack {
                            Spacer()
                            
                            // Contenido que cambia según el paso actual
                            Group {
                                switch step {
                                case .welcome:
                                    WelcomeStepView()
                                case .personalInfo:
                                    PersonalInfoStepView(name: $name, email: $email)
                                case .profilePhoto:
                                    ProfilePhotoStepView() // Renombrado para consistencia
                                case .settings:
                                    SettingsStepView()
                                }
                            }
                            .transition(.opacity.animation(.easeInOut))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // --- Footer de Navegación ---
                    OnboardingFooterView(
                        step: $step,
                        onNext: handleNext,
                        onBack: handleBack
                    )
                    
                    // Línea de acento del footer
                    Rectangle()
                        .fill(Color.brandPrimary.opacity(0.05))
                        .frame(height: 1)
                }
                .background(Color.white)
                .foregroundColor(Color.textPrimary)
                .ignoresSafeArea(edges: .bottom)
            }
        }
    
    // --- Lógica de Navegación ---
    // Esta lógica ahora vive en la vista padre, que es lo correcto.
    private func handleNext() {
        guard let currentIndex = steps.firstIndex(of: step) else { return }
        if currentIndex < steps.count - 1 {
            withAnimation {
                step = steps[currentIndex + 1]
            }
        } else {
            // El usuario ha presionado "COMENZAR" en el último paso
            print("Onboarding completado!")
            onComplete() // Notificamos a la vista RootView que hemos terminado
        }
    }
    
    private func handleBack() {
        guard let currentIndex = steps.firstIndex(of: step) else { return }
        if currentIndex > 0 {
            withAnimation {
                step = steps[currentIndex - 1]
            }
        }
    }
}


// MARK: - Componentes de UI para el Onboarding

struct OnboardingHeaderView: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "gearshape")
                    .font(.system(size: 20, weight: .light))
            }
            
            Spacer()
            Text("配置") // "Configuración" en japonés
                .font(.geist(12, weight: .light))
                .tracking(3.0)
            Spacer()
            
            // Spacer invisible para centrar el texto correctamente
            Color.clear.frame(width: 24, height: 24)
        }
        .foregroundColor(Color.textMuted)
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.brandPrimary.opacity(0.1))
                .offset(y: 30)
        )
    }
}

struct OnboardingFooterView: View {
    @Binding var step: OnboardingStep
    var onNext: () -> Void // Closure para notificar "siguiente"
    var onBack: () -> Void // Closure para notificar "atrás"
    
    var body: some View {
        VStack(spacing: 12) {
            GradientButton(title: step == .settings ? "COMENZAR" : "CONTINUAR") {
                onNext() // Llama al closure que le pasaron desde la vista padre
            }
            
            if step != .welcome {
                Button(action: { onBack() }) { // Llama al closure que le pasaron
                    Text("ATRÁS")
                        .font(.geist(14, weight: .bold))
                        .tracking(1.5)
                        .foregroundColor(Color.textMuted)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.brandPrimary.opacity(0.1))
                .offset(y: -45)
        )
    }
}



// MARK: - Vista Previa
#Preview {
    OnboardingView(onComplete: {
        print("Onboarding completado en la vista previa.")
    })
}
