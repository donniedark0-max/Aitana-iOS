//
//  PersonalInfoStepView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/8/25.
//

import SwiftUI

struct PersonalInfoStepView: View {
    @Binding var name: String
    @Binding var email: String
    
    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Text("Datos Personales")
                    .font(.geist(22, weight: .light))
                    .tracking(-0.5)
                    .padding(.bottom, 16)
                Rectangle()
                    .fill(Color.brandPrimary)
                    .frame(width: 32, height: 1)
            }
            
            VStack(spacing: 24) {
                VStack {
                    Text("Nombre Completo")
                        .font(.geist(12))
                        .tracking(2.0)
                        .foregroundColor(Color.textMuted)
                        .padding(.bottom, 12)
                    
                    TextField("Tu nombre", text: $name)
                        .font(.geist(14))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 12)
                        .background(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.brandPrimary.opacity(0.3))
                                .padding(.top, 40)
                        )
                }
                
                VStack {
                    Text("Correo Electrónico")
                        .font(.geist(12))
                        .tracking(2.0)
                        .foregroundColor(Color.textMuted)
                        .padding(.bottom, 12)
                    
                    TextField("tu@correo.com", text: $email)
                        .font(.geist(14))
                        .multilineTextAlignment(.center)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.vertical, 12)
                        .background(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.brandPrimary.opacity(0.3))
                                .padding(.top, 40)
                        )
                }
            }
        }
    }
}
