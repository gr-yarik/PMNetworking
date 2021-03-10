//
//  Foundation+Ext.swift
//  
//
//  Created by Yaroslav Hrytsun on 06.03.2021.
//

import Foundation

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" 
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension URLRequest {
    mutating func addHeaders(defaultHeaders: [String : String], requestHeaders: [String : String]) {
        let headers = requestHeaders.merging(defaultHeaders) { (current, _) in current }
    
        headers.forEach({
            self.setValue($0.value, forHTTPHeaderField: $0.key)
        })
    }
}
