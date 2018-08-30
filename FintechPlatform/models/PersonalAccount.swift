//
//  PersonalAccount.swift
//  FintechPlatform
//
//  Created by Matteo Stefanini on 29/08/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public struct PersonalAccount: Codable {
    var account: Account
    var accountLevel: AccountLevel
    var accountLevelStatus: AccountLevelStatus
}
