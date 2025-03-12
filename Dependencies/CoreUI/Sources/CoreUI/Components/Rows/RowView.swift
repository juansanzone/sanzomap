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
        
        public init(title: String, subtitle: String, imageName: String = "chevron.right") {
            self.title = title
            self.subtitle = subtitle
            self.imageName = imageName
        }
        
        public var body: some View {
            HStack {
                VStack(spacing: .Space.xSmall) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary.opacity(0.8))
                        .fullWidth()
                    HStack(spacing: .Space.xSmall) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text(subtitle)
                            .font(.caption2)
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
