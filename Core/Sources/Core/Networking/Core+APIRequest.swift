//
//  Core+.swift
//  Core
//
//  Created by Juan Sanzone on 10/03/2025.
//

import Foundation

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
