//
//  Aitana_iOSApp.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/7/25.
//

import SwiftUI

@main
struct Aitana_iOSApp: App {
    @StateObject private var coordinator = AppCoordinator()
       
    var body: some Scene {
        WindowGroup {
            RootView() // La app ahora arranca aquí.
                .environmentObject(coordinator)
        }
    }
}
