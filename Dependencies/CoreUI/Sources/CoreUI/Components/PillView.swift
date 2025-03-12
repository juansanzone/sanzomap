//
//  PillView.swift
//  CoreUI
//
//  Created by Juan Sanzone on 12/03/2025.
//

import SwiftUI

public extension CoreUI {
    public struct PillView: View {
        private let title: String
        
        public init(title: String) {
            self.title = title
        }
        
        public var body: some View {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .padding(.horizontal, .Space.medium)
                .padding(.vertical, .Space.small)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )
                .foregroundColor(.primary)
        }
    }
}
