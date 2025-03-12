//
//  Core+DataState.swift
//  Core
//
//  Created by Juan Sanzone on 11/03/2025.
//

import Foundation

extension Core.Foundation {
    public enum DataState<T> {
        case loading
        case loaded(T)
        case error(Error)
        
        public var data: T? {
            if case let .loaded(value) = self {
                return value
            }
            return nil
        }
          
        public var isLoading: Bool {
            if case .loading = self {
                return true
            }
            return false
        }
    }
}

extension Core.Foundation.DataState: Equatable where T: Equatable {
    public static func ==(lhs: Core.Foundation.DataState<T>, rhs: Core.Foundation.DataState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded(let leftValue), .loaded(let rightValue)):
            return leftValue == rightValue
        case (.error(let leftError), .error(let rightError)):
            // Compare using localizedDescription – adjust if needed.
            return leftError.localizedDescription == rightError.localizedDescription
        default:
            return false
        }
    }
}
