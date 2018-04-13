//
//  BankAccount.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
public struct BankAccount {
    
    public let bankaccountid: String
    public let iban: String
    public let activestate: String
    public let accountId: String?
    
    public init(bankaccountid: String,
         iban: String,
         activestate: String,
         accountId: String? = nil) {
        
        self.bankaccountid = bankaccountid
        self.iban = iban
        self.activestate = activestate
        self.accountId = accountId
    }
    
}
