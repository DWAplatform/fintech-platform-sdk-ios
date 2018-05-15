//
//  Error.swift
//  FintechPlatform
//
//  Created by ingrid on 14/05/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public struct ServerError{
    public let code: ErrorCode
    public let message: String
    
    init(code: ErrorCode, message: String) {
        self.code = code
        self.message = message
    }
}
