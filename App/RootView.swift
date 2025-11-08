//
//  RootView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/8/25.
//

import SwiftUI

struct RootView: View {
    // Este estado determinará qué vista se muestra.
    // En una app real, esto vendría de UserDefaults, Keychain, etc.
    @State private var isAuthenticated = false
    
    // Este estado controlará si se muestra el onboarding.
    // Lo pondremos en `true` para probarlo.
    @State private var needsOnboarding = true

    var body: some View {
        if isAuthenticated {
            // Si el usuario está autenticado, mostramos la pantalla principal.
            // Por ahora, será un simple texto. Más adelante será la LiveView con la cámara.
            Text("Pantalla Principal de AITANA")
                .sheet(isPresented: $needsOnboarding) {
                    // Si necesita onboarding, lo mostramos como una hoja modal.
                    OnboardingView(onComplete: {
                        // Cuando el onboarding termina, actualizamos el estado.
                        needsOnboarding = false
                    })
                }
        } else {
            // Si no, mostramos la vista de Login.
            LoginView(onLoginSuccess: {
                // Cuando el login es exitoso, actualizamos el estado.
                isAuthenticated = true
            })
        }
    }
}
