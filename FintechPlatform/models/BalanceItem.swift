//
//  BalanceItem.swift
//  FintechPlatform
//
//  Created by ingrid on 16/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
public struct BalanceItem: Codable {
    public let balance: Money
    public let availableBalance: Money
    
    public init(balance: Money,
                availableBalance: Money) {
        self.balance = balance
        self.availableBalance = availableBalance
    }
}
