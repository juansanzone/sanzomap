//
//  Core+NavigationRouter.swift
//  Core Architecture
//
//  Created by Juan Sanzone on 10/03/2025.
//

import SwiftUI

public extension Core.Architecture {
    protocol NavigationRouter: AnyObject, ObservableObject {
        associatedtype Destination: Hashable
        associatedtype DestinationView: View
        
        var navigationPath: NavigationPath { get set }
        var willChangeNavigationPathCallback: (() -> Void)? { get set }
        var presentingDestination: Destination? { get set }
        var isPresentingScreen: Bool { get set }
        
        func pop()
        func popToRoot()
        func push(screen: Destination)
        func push(_ view: any Hashable)
        
        func present(screen: Destination)
        func dismissPresentedScreen()
        
        @ViewBuilder
        func viewFor(for destination: Destination) -> DestinationView
        func setup(willChangeNavigationPathCallback callback: (() -> Void)?)
    }
}

extension Core.Architecture.NavigationRouter {
    func setup(willChangeNavigationPathCallback callback: (() -> Void)?) {
        willChangeNavigationPathCallback = callback
    }
}

extension Core.Architecture.NavigationRouter {
    func push(screen: Destination) {
        push(screen)
    }

    func push(_ view: any Hashable) {
        willChangeNavigationPathCallback?()
        navigationPath.append(view)
    }

    func pop() {
        if !navigationPath.isEmpty {
            willChangeNavigationPathCallback?()
            navigationPath.removeLast()
        }
    }

    func popToRoot() {
        willChangeNavigationPathCallback?()
        navigationPath = NavigationPath()
    }
}

extension Core.Architecture.NavigationRouter {
    func present(screen: Destination) {
        willChangeNavigationPathCallback?()
        presentingDestination = screen
        isPresentingScreen = true
    }

    func dismissPresentedScreen() {
        willChangeNavigationPathCallback?()
        presentingDestination = nil
        isPresentingScreen = false
    }
}
