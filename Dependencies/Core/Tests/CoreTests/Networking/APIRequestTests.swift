import XCTest
import Foundation
@testable import Core

final class APIRequestTests: XCTestCase {
    func test_init_shouldReturnDefaultValues() throws {
        let sut = Core.Networking.APIRequest.init(path: "/abc")
        
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.baseURL, "https://gist.githubusercontent.com")
        XCTAssertEqual(sut.path, "/abc")
        XCTAssertEqual(sut.cachePolicy, .returnCacheDataElseLoad)
        XCTAssertNil(sut.headers)
        XCTAssertNil(sut.parameters)
    }
}
