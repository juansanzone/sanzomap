import XCTest
import Foundation
@testable import Core

private class MockURLSession: Core.Networking.URLSessionProviding {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.mockData = data
        self.mockResponse = response
        self.mockError = error
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        guard let data = mockData, let response = mockResponse else {
            throw Core.Networking.NetworkError.invalidResponse
        }
        return (data, response)
    }
}
