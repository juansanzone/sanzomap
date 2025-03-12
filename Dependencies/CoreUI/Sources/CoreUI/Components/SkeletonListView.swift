//
//  SkeletonListView.swift
//  CoreUI
//
//  Created by Juan Sanzone on 12/03/2025.
//

import SwiftUI

public extension CoreUI {
    public struct SkeletonListView: View {
       private let numberOfItems: Int
        
        public init(numberOfItems: Int = 5) {
            self.numberOfItems = numberOfItems
        }
        
        public var body: some View {
            List {
                ForEach(0..<numberOfItems, id: \.self) { _ in
                    RowView(
                        title: "Some title...",
                        subtitle: "Some subtitle"
                   )
                }
            }
            .redacted(reason: .placeholder)
        }
    }
}
