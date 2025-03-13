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
        private let onFavToggle: (Bool) -> Void
        
        @State private var isFav: Bool
        
        public init(
            title: String,
            subtitle: String,
            imageName: String = "chevron.right",
            bulletColor: Color = .pink,
            isFav: Bool,
            onFavToggle: @escaping (Bool) -> Void,
            onTapAction: @escaping () -> Void
        ) {
            self.title = title
            self.subtitle = subtitle
            self.imageName = imageName
            self.bulletColor = bulletColor
            self.onFavToggle = onFavToggle
            self.onTapAction = onTapAction
            _isFav = State(initialValue: isFav)
        }
        
        public var body: some View {
            HStack {
                Button {
                    onTapAction()
                } label: {
                    VStack(spacing: .Space.xSmall) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.regular)
                            .fontDesign(.rounded)
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
                }
                .tint(Color.primary)
            }
            .swipeActions(edge: .trailing) {
                Button {
                    isFav.toggle()
                    onFavToggle(isFav)
                } label: {
                    Image(systemName: "star.fill")
                }
                .tint(isFav ? .yellow : .gray)
            }
        }
    }
}
