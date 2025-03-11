//
//  View+FullWidth.swift
//  CoreUI
//
//  Created by Juan Sanzone on 11/03/2025.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func fullWidth(alignment: Alignment = .leading) -> some View {
        modifier(FullWidthModifier(alignment: alignment))
    }
}

fileprivate struct FullWidthModifier: ViewModifier {
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}
