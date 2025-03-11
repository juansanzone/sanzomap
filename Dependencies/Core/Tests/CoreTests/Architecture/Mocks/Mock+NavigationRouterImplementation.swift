import SwiftUI
@testable import Core

final class MockNavigationRouterImplementation: Core.Architecture.NavigationRouter {
    enum TestDestination: Hashable {
        case screenA
        case screenB
    }
    
    @Published var navigationPath: NavigationPath = NavigationPath()
    @Published var presentingDestination: TestDestination?
    @Published var isPresentingScreen: Bool = false
    var willChangeNavigationPathCallback: (() -> Void)?
    
    init() {}
}

extension MockNavigationRouterImplementation {
    @ViewBuilder
    func viewFor(for destination: TestDestination) -> some View {
        switch destination {
        case .screenA:
            Text("Screen A")
        case .screenB:
            Text("Screen B")
        }
    }
}
