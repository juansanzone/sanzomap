//
//  Core+KeyPathMutable.swift
//  Core Architecture
//
//  Created by Juan Sanzone on 10/03/2025.
//

import Foundation

public extension Core.Architecture {
    protocol KeyPathMutable {
        func modifying<T>(_ keyPath: WritableKeyPath<Self, T>, to value: T) -> Self
    }
}

extension Core.Architecture.KeyPathMutable {
    public func modifying<T>(_ keyPath: WritableKeyPath<Self, T>, to value: T) -> Self {
        modified { $0[keyPath: keyPath] = value }
    }

    static func .= <T>(lhs: Self, rhs: (WritableKeyPath<Self, T>, T)) -> Self {
        lhs.modifying(rhs.0, to: rhs.1)
    }
    
    private func modified(_ update: (inout Self) -> Void) -> Self {
        var viewState = self
        update(&viewState)
        return viewState
    }
}

infix operator .=: AdditionPrecedence
