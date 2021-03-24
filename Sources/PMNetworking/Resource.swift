//
//  Resource.swift
//  
//
//  Created by Yaroslav Hrytsun on 06.03.2021.
//

import Foundation

public enum RequestMethod {
    case GET
    case POST(requestBody: [String : Any] = [:])
    case PUT(requestBody: [String : Any] = [:])
    case DELETE
    
    var rawValue: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        case .PUT:
            return "PUT"
        case .DELETE:
            return "DELETE"
        }
    }
}

public struct Resource<T: Codable> {
    
    let url: URL
    let requestMethod: RequestMethod
    let headers: [String : String]
    let decodingType: T.Type
    let customResponseCodeHandler: ((Int) throws -> Void)?
    
    public init(url: URL, requestMethod: RequestMethod, headers: [String : String] = [:], decodingType: T.Type, customResponseCodeHandler: ((Int) throws -> Void)?) {
        self.url = url
        self.requestMethod = requestMethod
        self.headers = headers
        self.decodingType = decodingType
        self.customResponseCodeHandler = customResponseCodeHandler
    }
    
    public func prepareRequest(forNetworking networking: Networking) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
  
        switch requestMethod {
        case .GET, .DELETE:
            break
        case .PUT(let body), .POST(let body):
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        }
        
        request.addHeaders(defaultHeaders: networking.defaultHeaders, requestHeaders: headers)
        request.httpShouldHandleCookies = true
        return request
    }
}
