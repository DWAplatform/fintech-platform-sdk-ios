//
//  TransactionsResponse.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
struct TransactionResponse {
    
    let transactionId: String
    let accountId: String
    let status: String
    let operationtype: String
    let creationdate: String
    let creditedid: String?
    let debitedId: String?
    let creditedFunds: Int64?
    let debitedFunds: Int64?
    let creditedName: String?
    let debitedName: String?
    let creditedPhoto: String?
    let debitedPhoto: String?
    let error: String?
    let message: String?
    
    init(transactionId: String,
         accountId: String,
         status: String,
         operationtype: String,
         creationdate: String,
         creditedid: String? = nil,
         debitedId: String? = nil,
         creditedFunds: Int64? = nil,
         debitedFunds: Int64? = nil,
         creditedName: String? = nil,
         debitedName: String? = nil,
         creditedPhoto: String? = nil,
         debitedPhoto: String? = nil,
         error: String? = nil,
         message: String? = nil) {
        self.transactionId = transactionId
        self.accountId = accountId
        self.status = status
        self.operationtype = operationtype
        self.creationdate = creationdate
        self.creditedid = creditedid
        self.debitedId = debitedId
        self.creditedFunds = creditedFunds
        self.debitedFunds = debitedFunds
        self.creditedName = creditedName
        self.debitedName = debitedName
        self.creditedPhoto = creditedPhoto
        self.debitedPhoto = debitedPhoto
        self.error = error
        self.message = message
    }
}
