import XCTest
import SwiftUI
@testable import Core

final class NavigationRouterTests: XCTestCase {
    private var router: MockNavigationRouterImplementation!
    private var callbackCount: Int = 0
    
    override func setUp() {
        super.setUp()
        router = MockNavigationRouterImplementation()
        callbackCount = 0
        router.setup { [weak self] in
            self?.callbackCount += 1
        }
    }
    
    override func tearDown() {
        router = nil
        callbackCount = 0
        super.tearDown()
    }
}

extension NavigationRouterTests {
    func test_pushScreen_shouldIncreasesNavigationPathCount() {
        let initialCount = router.navigationPath.count
        
        router.push(screen: .screenA)
        
        XCTAssertEqual(
            router.navigationPath.count, initialCount + 1,
            "Push screen should increase navigation path count"
        )
        XCTAssertEqual(callbackCount, 1, "callback should be triggered on push")
    }
    
    func test_pushHashable_shouldIncreasesNavigationPathCount() {
        let initialCount = router.navigationPath.count
        let genericHashable = "TestString" as (any Hashable)
        
        router.push(genericHashable)
        
        XCTAssertEqual(
            router.navigationPath.count, initialCount + 1,
            "Push generic hashable should increase navigation path count"
        )
        XCTAssertEqual(callbackCount, 1, "callback should be triggered on push")
    }
    
    func test_pop_shouldDecreasesNavigationPathCount() {
        router.push(screen: .screenA)
        
        let initialCount = router.navigationPath.count
        router.pop()
        
        XCTAssertEqual(
            router.navigationPath.count, initialCount - 1,
            "Pop should decrease navigation path count"
        )
        XCTAssertEqual(callbackCount, 2, "callback should be triggered on pop")
    }
    
    func test_pop_whenEmpty_doesNothing() {
        let initialCount = router.navigationPath.count
        
        router.pop()
        
        XCTAssertEqual(
            router.navigationPath.count,
            initialCount,
            "Pop on empty path should do nothing"
        )
        XCTAssertEqual(callbackCount, 0, "callback should not be triggered on empty pop")
    }
    
    func test_popToRoot_shouldClearsNavigationPath() {
        router.push(screen: .screenA)
        router.push(screen: .screenB)
        
        router.popToRoot()
        
        XCTAssertEqual(router.navigationPath.count, 0, "Pop to root should clear navigation path")
        XCTAssertEqual(callbackCount, 3, "callback should be triggered on popToRoot")
    }
    
    func test_present_shouldSetsDestinationAndFlagProperty() {
        let screen = MockNavigationRouterImplementation.TestDestination.screenA
        
        router.present(screen: screen)
        
        XCTAssertEqual(router.presentingDestination, screen, "Present should set the presenting destination")
        XCTAssertTrue(router.isPresentingScreen, "Present should set isPresentingScreen - TRUE")
        XCTAssertEqual(callbackCount, 1, "callback should be triggered on present")
    }
    
    func test_dismissPresented_shouldClearsDestinationAndFlagProperty() {
        router.present(screen: .screenA)
        
        router.dismissPresentedScreen()
        
        XCTAssertNil(router.presentingDestination, "Dismiss should clear presenting destination")
        XCTAssertFalse(router.isPresentingScreen, "Dismiss should set isPresentingScreen - FALSE")
        XCTAssertEqual(callbackCount, 2, "callback should be triggered on dismiss")
    }
    
    func test_performNavigationActions_shouldTriggerCallback() {
        router.push(screen: .screenA)
        XCTAssertEqual(callbackCount, 1, "callback should be triggered once after push")
        
        router.pop()
        XCTAssertEqual(callbackCount, 2, "callback should be triggered again after pop")
        
        router.present(screen: .screenB)
        XCTAssertEqual(callbackCount, 3, "callback should be triggered again after present")
        
        router.dismissPresentedScreen()
        XCTAssertEqual(callbackCount, 4, "callback should be triggered again after dismiss")
    }
}
