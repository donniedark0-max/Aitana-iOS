//
//  WelcomeStepView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/8/25.
//

import SwiftUI

struct WelcomeStepView: View {
    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Text("AITANA 2.0")
                    .font(.geist(24, weight: .light))
                    .tracking(-0.5)
                    .padding(.bottom, 12)
                
                Rectangle()
                    .fill(Color.brandPrimary)
                    .frame(width: 32, height: 1)
                    .padding(.bottom, 24)
                
                Text("Bienvenido a tu asistente de visión impulsado por IA. Configuraremos tu perfil para personalizar tu experiencia.")
                    .font(.geist(14))
                    .foregroundColor(Color.textPrimary.opacity(0.8))
                    .lineSpacing(6)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                Text("P E R F E C C I Ó N")
                    .font(.geist(12))
                    .foregroundColor(Color.textMuted)
                    .tracking(3.0)
                
                Text("Cada funcionalidad está diseñada para máxima claridad y eficiencia minimalista.")
                    .font(.geist(12))
                    .foregroundColor(Color.textPrimary.opacity(0.6))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 16)
        }
    }
}
