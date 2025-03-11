//
//  RowView.swift
//  CoreUI
//
//  Created by Juan Sanzone on 11/03/2025.
//

import SwiftUI

public extension CoreUI {
    @ViewBuilder
    static func rowView(title: String, subtitle: String) -> some View {
        HStack {
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary.opacity(0.8))
                    .fullWidth()
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                        .fullWidth()
                }
            }
            Image(systemName: "chevron.right")
                .foregroundColor(Color.gray)
        }
    }
}
