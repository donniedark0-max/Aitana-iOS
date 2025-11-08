//
//  Font+Extensions.swift
//  Aitana-iOS
//
//  Created by Juan Vilca on 11/7/25.
//

import SwiftUI

extension Font {
    /// La fuente principal de la aplicación, Geist.
    static func geist(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        // El nombre aquí debe ser el "PostScript name" de la fuente.
        // Para los archivos OTF estáticos, el nombre del archivo (sin extensión) suele ser el correcto.
        let fontName: String
        switch weight {
        case .bold:
            fontName = "Geist-Bold"
        // No tenemos otros pesos, así que todo lo demás usará Regular.
        default:
            fontName = "Geist-Regular"
        }
        return .custom(fontName, size: size)
    }
    
    /// La fuente monoespaciada de la aplicación, Geist Mono.
    static func geistMono(_ size: CGFloat) -> Font {
        return .custom("GeistMono-Regular", size: size)
    }
}
