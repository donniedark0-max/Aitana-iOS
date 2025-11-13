//
//  RootView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/8/25.
//
import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        if !coordinator.isAuthenticated {
            LoginView(onLoginSuccess: {
                withAnimation { coordinator.login() }
            })
        } else {
            if coordinator.needsOnboarding {
                OnboardingView(onComplete: {
                    withAnimation { coordinator.completeOnboarding() }
                })
            } else {
                NavigationStack(path: $coordinator.path) {
                    LiveView()
                        .navigationDestination(for: String.self) { destination in
                            if destination == "dashboard" {
                                DashboardView()
                            }
                        }
                }
            }
        }
    }
}
