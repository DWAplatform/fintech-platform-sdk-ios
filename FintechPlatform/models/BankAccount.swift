//
//  BankAccount.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
struct BankAccount {
    
    let bankaccountid: String
    let iban: String
    let activestate: String
    let accountId: String?
    
    init(bankaccountid: String,
         iban: String,
         activestate: String,
         accountId: String? = nil) {
        
        self.bankaccountid = bankaccountid
        self.iban = iban
        self.activestate = activestate
        self.accountId = accountId
    }
    
}
