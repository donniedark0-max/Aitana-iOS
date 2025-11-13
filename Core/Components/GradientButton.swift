//
//  GradientButto.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/8/25.
//

import SwiftUI

struct GradientButton: View {
    var title: String
    var action: () -> Void
    
    let gradientColors = [Color.brandPrimary, Color.brandSecondary]
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.geist(14, weight: .bold))
                .tracking(1.1)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(30) // Aplicando el radio de esquina que definiste
                .buttonStyle(.glassProminent)
        }
    }
}
