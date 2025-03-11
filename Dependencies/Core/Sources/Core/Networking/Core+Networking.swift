//
//  Core+Networking.swift
//  Core Networking
//
//  Created by Juan Sanzone on 10/03/2025.
//

import Foundation

public extension Core.Networking {
    protocol HTTPRequestable {
        var baseURL: String { get }
        var path: String { get }
        var method: HTTPMethod { get }
        var headers: [String: String]? { get }
        var parameters: [String: Any]? { get }
        var cachePolicy: NSURLRequest.CachePolicy { get }
    }
    
    protocol NetworkServicing {
        func fetch<T: Decodable>(request: HTTPRequestable) async throws -> T
    }
    
    protocol URLSessionProviding {
        func data(for request: URLRequest) async throws -> (Data, URLResponse)
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
    }
}

public extension Core.Networking.HTTPRequestable {
    var url: URL? {
        URL(string: baseURL + path)
    }
    
    var method: Core.Networking.HTTPMethod { .get }
    var headers: [String: String]? { nil }
    var parameters: [String: Any]? { nil }
}

extension URLSession: Core.Networking.URLSessionProviding {}
