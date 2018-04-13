//
//  TransactionsResponse.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
public struct TransactionResponse {
    
    public let transactionId: String
    public let accountId: String
    public let status: String
    public let operationtype: String
    public let creationdate: String
    public let creditedid: String?
    public let debitedId: String?
    public let creditedFunds: Int64?
    public let debitedFunds: Int64?
    public let creditedName: String?
    public let debitedName: String?
    public let creditedPhoto: String?
    public let debitedPhoto: String?
    public let error: String?
    public let message: String?
    
    public init(transactionId: String,
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
