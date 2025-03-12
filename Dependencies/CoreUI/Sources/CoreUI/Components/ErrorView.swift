//
//  ErrorView.swift
//  CoreUI
//
//  Created by Juan Sanzone on 11/03/2025.
//

import SwiftUI

public extension CoreUI {
    public struct ErrorView: View {
        private let imageSize: CGSize
        private let imageName: String?
        private let title: String
        private let error: Error?
        private let retryText: String
        private let onRetry: (() -> Void)

        public init(
            imageSize: CGSize = .init(width: 60, height: 60),
            imageName: String? = "x.circle",
            title: String = "Something went wrong 😑",
            error: Error? = nil,
            retryText: String = "Try again",
            onRetry: @escaping (() -> Void)
        ) {
            self.imageSize = imageSize
            self.imageName = imageName
            self.title = title
            self.error = error
            self.retryText = retryText
            self.onRetry = onRetry
        }

        public var body: some View {
            VStack(spacing: .Space.medium) {
                if let imageName {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red.opacity(0.8))
                        .frame(width: imageSize.width, height: imageSize.height)
                }
                VStack {
                    Text(title)
                        .font(imageName == nil ? .body : .headline)
                        .fontDesign(.rounded)
                        .foregroundColor(.primary.opacity(0.8))
                        .multilineTextAlignment(.center)
                    if let error {
                        Text(error.localizedDescription)
                            .font(.callout)
                            .fontDesign(.rounded)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                }
                Button(retryText) {
                    onRetry()
                }
            }
        }
    }
}
