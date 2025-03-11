//
//  Core+NetworkService.swift
//  Core Networking
//
//  Created by Juan Sanzone on 10/03/2025.
//

import Foundation

public extension Core.Networking {
    final class NetworkService: NetworkServicing {
        private let session: URLSessionProviding
        
        public init(session: URLSessionProviding = URLSession.shared) {
            self.session = session
        }
        
        public func fetch<T: Decodable>(request: HTTPRequestable) async throws -> T {
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
