//
//  UserProfileResponse.swift
//  FintechPlatform
//
//  Created by ingrid on 11/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
public struct UserProfileResponse {
    public let userid: String
    public var token: String?
    
    init(userid: String) {
        self.userid = userid
    }
}
