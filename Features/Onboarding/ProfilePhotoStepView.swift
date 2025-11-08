//
//  ProfilePhotoStepView.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/8/25.
//

import SwiftUI

struct ProfilePhotoStepView: View {
    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Text("Foto de Perfil")
                    .font(.geist(22, weight: .light))
                    .tracking(-0.5)
                    .padding(.bottom, 16)
                Rectangle()
                    .fill(Color.brandPrimary)
                    .frame(width: 32, height: 1)
            }
            
            VStack(spacing: 8) {
                Image(systemName: "person.fill")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(Color.textMuted)
                    .frame(width: 96, height: 96)
                    .background(
                        Circle().stroke(Color.brandPrimary.opacity(0.4), lineWidth: 2)
                    )
                    .padding(.vertical, 48)
                
                Text("S E L E C C I O N A")
                    .font(.geist(12))
                    .foregroundColor(Color.textMuted)
                    .tracking(2.5)
                
                Text("Sube o toma una foto")
                    .font(.geist(12))
                    .foregroundColor(Color.textMuted.opacity(0.6))
                    .padding(.top, 4)
            }
        }
    }
}
