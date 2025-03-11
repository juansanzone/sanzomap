// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// Namespace that groups all core-related code.
public enum Core {}

extension Core {
    enum Networking {
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
}

extension Core.Networking {
    struct APIRequest: HTTPRequestable {
        let baseURL: String
        let path: String
        let method: HTTPMethod
        let cachePolicy: NSURLRequest.CachePolicy
        let headers: [String: String]?
        let parameters: [String: Any]?
        
        init(
            baseURL: String = "https://gist.githubusercontent.com",
            path: String,
            method: HTTPMethod = .get,
            cachePolicy: NSURLRequest.CachePolicy = .returnCacheDataElseLoad,
            headers: [String: String]? = nil,
            parameters: [String: Any]? = nil
        ) {
            self.baseURL = baseURL
            self.path = path
            self.method = method
            self.cachePolicy = cachePolicy
            self.headers = headers
            self.parameters = parameters
        }
    }
}

extension Core.Networking {
    final class NetworkService: NetworkServicing {
        private let session: URLSessionProviding
        
        init(session: URLSessionProviding = URLSession.shared) {
            self.session = session
        }
        
        func fetch<T: Decodable>(request: HTTPRequestable) async throws -> T {
            guard let url = request.url else {
                throw NetworkError.invalidURL
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.cachePolicy = request.cachePolicy
            
            urlRequest.setValue("max-age=3600", forHTTPHeaderField: "Cache-Control")
            
            request.headers?.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            
            if let parameters = request.parameters, request.method != .get {
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            }
            
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}

extension Core.Networking.HTTPRequestable {
    var url: URL? {
        URL(string: baseURL + path)
    }
    
    var method: Core.Networking.HTTPMethod { .get }
    var headers: [String: String]? { nil }
    var parameters: [String: Any]? { nil }
}

extension URLSession: Core.Networking.URLSessionProviding {}
