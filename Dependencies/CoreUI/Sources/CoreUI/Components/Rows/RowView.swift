//
//  RowView.swift
//  CoreUI
//
//  Created by Juan Sanzone on 11/03/2025.
//

import SwiftUI

public extension CoreUI {
    public struct RowView: View {
        private let title: String
        private let subtitle: String
        private let imageName: String
        private let bulletColor: Color
        private let onTapAction: () -> Void
        
        public init(
            title: String,
            subtitle: String,
            imageName: String = "chevron.right",
            bulletColor: Color = .pink,
            onTapAction: @escaping () -> Void
        ) {
            self.title = title
            self.subtitle = subtitle
            self.imageName = imageName
            self.bulletColor = bulletColor
            self.onTapAction = onTapAction
        }
        
        public var body: some View {
            Button {
                onTapAction()
            } label: {
                HStack {
                    VStack(spacing: .Space.xSmall) {
                        Text(title)
                            .font(.headline)
                            .fontDesign(.rounded)
                            .foregroundStyle(.primary.opacity(0.8))
                            .fullWidth()
                        HStack(spacing: .Space.xSmall) {
                            Circle()
                                .fill(bulletColor)
                                .frame(width: 8, height: 8)
                            Text(subtitle)
                                .font(.caption2)
                                .fontDesign(.rounded)
                                .foregroundStyle(.gray)
                                .fullWidth()
                        }
                    }
                    Image(systemName: imageName)
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}
