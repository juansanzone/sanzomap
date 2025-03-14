//
//  CityRowView.swift
//  MapFeature
//
//  Created by Juan Sanzone on 14/03/2025.
//

import CoreUI

struct CityRowView: View {
    private let title: String
    private let subtitle: String
    private let onTapAction: () -> Void
    private let onFavToggle: (Bool) -> Void
    
    @State private var isFav: Bool
    @State private var showFavFeedback: Bool = false
    
    public init(
        title: String,
        subtitle: String,
        isFav: Bool,
        onFavToggle: @escaping (Bool) -> Void,
        onTapAction: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.onFavToggle = onFavToggle
        self.onTapAction = onTapAction
        _isFav = State(initialValue: isFav)
    }
    
    var body: some View {
        ZStack {
            CoreUI.RowView(
                title: title,
                subtitle: subtitle,
                isFav: isFav,
                onTapAction: onTapAction
            )
            .overlay {
                if showFavFeedback {
                    VStack {
                        HStack {
                            Spacer()
                            Text(isFav ? "Faved" : "Unfaved")
                            Image(systemName: "star.circle.fill")
                                .foregroundStyle(isFav ? .yellow : .gray)
                                .font(.system(size: 16))
                        }
                    }
                }
            }
            .swipeActions(edge: .trailing) {
                Button {
                    isFav.toggle()
                    withAnimation {
                        showFavFeedback = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showFavFeedback = false
                        }
                    }
                    onFavToggle(isFav)
                } label: {
                    Image(systemName: "star.fill")
                }
                .tint(isFav ? .gray : .yellow)
            }
        }
    }
}
