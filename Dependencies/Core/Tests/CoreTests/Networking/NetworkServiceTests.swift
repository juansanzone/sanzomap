import XCTest
import Foundation
@testable import Core

final class NetworkServiceTests: XCTestCase {
    func test_successfulFetch_shouldParseDTO() async throws {
        let sampleData = try JSONEncoder().encode(TestModel(id: 1, name: "Test"))
        let response = HTTPURLResponse(
            url: URL(string: "https://gist.githubusercontent.com/test")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let mockSession = MockURLSession(data: sampleData, response: response)
        let service = Core.Networking.NetworkService(session: mockSession)
        let request = Core.Networking.APIRequest(
            path: "/test",
            method: .get
        )
        let result: TestModel = try await service.fetch(request: request)
        
        XCTAssertEqual(result, TestModel(id: 1, name: "Test"), "Should successfully fetch and decode data")
    }
        
    func test_invalidResponseStatusCode_shouldReturnInvalidResponse() async {
        let sampleData = try! JSONEncoder().encode(TestModel(id: 1, name: "Test"))
        let response = HTTPURLResponse(
            url: URL(string: "https://google.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!
        let mockSession = MockURLSession(data: sampleData, response: response)
        let service = Core.Networking.NetworkService(session: mockSession)
        let request = Core.Networking.APIRequest(path: "/test")
        
        do {
            let _: TestModel = try await service.fetch(request: request)
            XCTFail("Expected invalidResponse error but fetch succeeded")
        } catch Core.Networking.NetworkError.invalidResponse {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func test_decodingError_shouldReturnNetworkError() async {
        let invalidData = "{ invalid json structure }".data(using: .utf8)!
        let response = HTTPURLResponse(
            url: URL(string: "https://google.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let mockSession = MockURLSession(data: invalidData, response: response)
        let service = Core.Networking.NetworkService(session: mockSession)
        let request = Core.Networking.APIRequest(path: "/test")
        
        do {
            let _: TestModel = try await service.fetch(request: request)
            XCTFail("Expected decoding error but fetch succeeded")
        } catch {
            XCTAssertTrue(
                error is DecodingError || error is Core.Networking.NetworkError,
                "Expected decoding-error: \(error)"
            )
        }
    }
}
