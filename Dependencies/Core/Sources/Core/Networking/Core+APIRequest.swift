//
//  Core+APIRequest.swift
//  Core Networking
//
//  Created by Juan Sanzone on 10/03/2025.
//

import Foundation

public extension Core.Networking {
    struct APIRequest: HTTPRequestable {
        public let baseURL: String
        public let path: String
        public let method: HTTPMethod
        public let cachePolicy: NSURLRequest.CachePolicy
        public let headers: [String: String]?
        public let parameters: [String: Any]?
        
        public init(
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
