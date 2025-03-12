//
//  Core+KeyPathMutable.swift
//  Core Architecture
//
//  Created by Juan Sanzone on 10/03/2025.
//

import Foundation

public extension Core.Architecture {
    public protocol KeyPathMutable {
        func modifying<T>(_ keyPath: WritableKeyPath<Self, T>, to value: T) -> Self
    }
}

public extension Core.Architecture.KeyPathMutable {
    func modifying<T>(_ keyPath: WritableKeyPath<Self, T>, to value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}
