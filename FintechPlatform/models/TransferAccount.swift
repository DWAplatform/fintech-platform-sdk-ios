//
//  TransferAccountModel.swift
//  FintechPlatform
//
//  Created by ingrid on 03/07/2019.
//  Copyright © 2019 Fintech Platform. All rights reserved.
//

import Foundation
public struct TransferAccount: Codable {
    public let  qrCreditTransferId: String
    public let creditedAccount: CreditedAccount
//    public let  created: String?
    public let  amount: Money?
    public let  message: String?
//    public let error: ServerError?
    
    public init(qrCreditTransferId: String,
                creditedAccount: CreditedAccount,
                amount: Money?=nil,
                message: String?=nil
//                created: String?=nil
        ) {
        self.qrCreditTransferId = qrCreditTransferId
//        self.created = created
        self.amount = amount
        self.message = message
        self.creditedAccount = creditedAccount
    }
}

public struct CreditedAccount: Codable {
    public let ownerId: String
    public let  accountId: String
    public let  tenantId: String
    public let  accountType: AccountType
    public let  name: String?
    public let  surname: String?
    public let  picture: String?
    
    public init(ownerId: String,
        accountId: String,
        tenantId: String,
        accountType: AccountType,
        name: String?=nil,
        surname: String?=nil,
        picture: String?=nil) {
        
        self.ownerId = ownerId
        self.accountId = accountId
        self.tenantId = tenantId
        self.accountType = accountType
        self.name = name
        self.surname = surname
        self.picture = picture
    }
}
