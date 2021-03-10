//
//  PMNetworking.swift
//  PMNetworkingTestingProject
//
//  Created by Yaroslav Hrytsun on 05.03.2021.
//

import Foundation

public protocol Networking {
    var defaultHeaders: [String : String] { get }
}

public struct PMNetworking: Networking {
    
    public private(set) var defaultHeaders: [String : String]
    
    public init(defaultHeaders: [String : String] = [:]) {
        self.defaultHeaders = defaultHeaders
    }
    
    private let responseCodeHandler: (Int) throws -> Void = { responseCode in
        print("Responce code: ", responseCode)
        switch responseCode {
        case 200..<300:
            return
        default:
            throw PMNetworkingError.invalidStatus
        }
    }
    
    
    public func networkCall<T: Decodable>(with resource: Resource<T>, then: @escaping (Result<T, PMNetworkingError>) -> Void) {
        let request = resource.prepareRequest(forNetworking: self)
        let session = URLSession(configuration: .default)
        session.configuration.httpShouldSetCookies = true
        session.configuration.httpCookieAcceptPolicy = .always
//        I guess .default configuration of URLSession ensures that cookies are saved and attached automatically
        session.dataTask(with: request) { data, response, error in
            if let _ = error {
                then(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                then(.failure(.invalidResponse))
                return
            }
            
            if let error = handleResponseCode(response.statusCode, responseCodeHandler: resource.customResponseCodeHandler) {
                then(.failure(error))
                return
            }
            
            guard let data = data else {
                then(.failure(.invalidData))
                return
            }

            let decoder = JSONDecoder()
            do {
                let parsedData = try decoder.decode(T.self, from: data)
                then(.success(parsedData))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    func handleResponseCode(_ responseCode: Int, responseCodeHandler: ((Int) throws -> Void)?) -> PMNetworkingError? {
        do {
            if let responseCodeHandler = responseCodeHandler {
                try responseCodeHandler(responseCode)
            } else {
                try self.responseCodeHandler(responseCode)
            }
        }
        catch let error {
            return error as? PMNetworkingError ?? nil
        }
        return nil
    }
}
