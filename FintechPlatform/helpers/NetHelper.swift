//
//  NetHelper.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
public class NetHelpers {
    
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
}
