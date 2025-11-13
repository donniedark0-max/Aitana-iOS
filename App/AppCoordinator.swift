//
//  AppCoordinator.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/10/25.
//

import SwiftUI
import Combine

enum ActiveSheet: Identifiable {
    case settings
    var id: Int { hashValue }
}

@MainActor
class AppCoordinator: ObservableObject {
    @Published var isAuthenticated = false
    @Published var path = NavigationPath()
    @Published var activeSheet: ActiveSheet?
    @Published var needsOnboarding = true
    
    func login() { isAuthenticated = true }
    func logout() { isAuthenticated = false; path = NavigationPath() }
    func completeOnboarding() { needsOnboarding = false }
    func showSettings() { activeSheet = .settings }
    func goToDashboard() { path.append("dashboard") }
    func goBack() { if !path.isEmpty { path.removeLast() } }
}
