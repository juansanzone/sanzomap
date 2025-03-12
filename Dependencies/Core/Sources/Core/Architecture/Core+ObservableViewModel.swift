//
//  Core+ObservableViewModel.swift
//  Core Architecture
//
//  Created by Juan Sanzone on 10/03/2025.
//

import SwiftUI

public extension Core.Architecture {
    @MainActor
    protocol ObservableViewModel: ObservableObject {
        associatedtype State: KeyPathMutable, Equatable
        associatedtype Action: Equatable

        var state: State { get }

        func send(_ action: Action) async
    }
}
