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

    static func createRequestError(data: Data, error: Error?) -> Error {
        do {
            let optErrorResponse = try JSONSerialization.jsonObject(
                with: data,
                options: []) as? [[String:String]]
        
            if let errorResponse = optErrorResponse {
                var errorsList = [ServerError]()
                for item in errorResponse {
                    
                    if let code = item["code"], let message = item["message"] {
                        
                        if let errorCode = ErrorCode(rawValue: code){
                            errorsList.append(ServerError(code: errorCode, message: message))
                        } else {
                            errorsList.append(ServerError(code: ErrorCode.unknown_error, message: message))
                        }
                    }
                }
                return WebserviceError.APIResponseError(serverErrors: errorsList, error: error)
            } else {
                return WebserviceError.NOJSONReply
            }
        } catch {
            return WebserviceError.NOJSONReply
        }
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

public enum WebserviceError : Error {
    case DataEmptyError
    case NoHTTPURLResponse
    case StatusCodeNotSuccess
    case EncodeInputParamsError
    case MissingMandatoryReplyParameters
    case NOJSONReply
    case IdempotencyError
    case TokenError
    case ResourseNotFound
    case APIResponseError(serverErrors: [ServerError]?, error: Error?)
}

extension URLRequest {
    mutating func addBearerAuthorizationToken(token: String) {
        self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
