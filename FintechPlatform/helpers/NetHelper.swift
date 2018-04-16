//
//  NetHelper.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
class NetHelper {
    
    static func getPath(from accountType: String) -> String {
        if(accountType == "PERSONAL"){
            return "users"
        } else {
            return "enterprises"
        }
    }
    
    static func getUrlDataString(url: String, params: Dictionary<String, String>) -> String {
        var result = ""
        var first = true
        result.append(url)
        for (key, value) in params {
            if(first) {
                result.append("?")
                first = false
            } else {
                result.append("&")
                result.append(key)
                result.append("=")
                result.append(value)
            }
        }
        return result
    }

}

protocol SessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
        -> URLSessionDataTask
    
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
    
}

extension URLSession: SessionProtocol {}

enum WebserviceError : Error {
    case DataEmptyError
    case NoHTTPURLResponse
    case StatusCodeNotSuccess
    case EncodeInputParamsError
    case MissingMandatoryReplyParameters
    case NOJSONReply
    case IdempotencyError
    case TokenError
    case ResourseNotFound
}

extension URLRequest {
    mutating func addBearerAuthorizationToken(token: String) {
        self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
