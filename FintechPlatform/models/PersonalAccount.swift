//
//  PersonalAccount.swift
//  FintechPlatform
//
//  Created by Matteo Stefanini on 29/08/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public struct PersonalAccount: Codable {
    public var account: Account
    public var accountLevel: AccountLevel
    public var accountLevelStatus: AccountLevelStatus
}
