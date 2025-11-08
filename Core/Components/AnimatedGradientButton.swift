//
//  AnimatedGradientButton.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/7/25.
//

import SwiftUI

struct AnimatedGradientButton: View {
    var title: String
    var action: () -> Void
    
    // NUEVO: Un simple "interruptor" para activar la animación.
    @State private var isAnimating = false
    
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
                    // CORREGIDO: Los puntos de inicio y fin ahora dependen del estado 'isAnimating'.
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: isAnimating ? UnitPoint(x: 1, y: 0.5) : UnitPoint(x: -1, y: 0.5),
                        endPoint: isAnimating ? UnitPoint(x: 2, y: 0.5) : UnitPoint(x: 0, y: 0.5)
                    )
                    // CORREGIDO: Aplicamos el modificador de animación directamente al gradiente.
                    // Le decimos que observe el valor de 'isAnimating'.
                    .animation(
                        .easeInOut(duration: 4.5).repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                )
                .cornerRadius(30)
                .onAppear {
                    // CORREGIDO: Simplemente activamos el "interruptor" cuando la vista aparece.
                    isAnimating = true
                }
        }
    }
}
