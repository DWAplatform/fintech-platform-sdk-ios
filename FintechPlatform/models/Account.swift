//
//  Account.swift
//  FintechPlatform
//
//  Created by ingrid on 22/08/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public class Account {
    private let tenantId: UUID
    private let accountType: AccountType
    private let ownerId: UUID
    private let accountId: UUID
    
    private init(tenantId: UUID,
                  accountType: AccountType,
                  ownerId: UUID,
                  accountId: UUID){
        self.tenantId = tenantId
        self.accountType = accountType
        self.ownerId = ownerId
        self.accountId = accountId
    }
    
    public static func personalAccount(user: User,
                                       accountId: UUID) -> Account {
        return Account(tenantId: user.tenantId, accountType: AccountType.PERSONAL, ownerId: user.userId, accountId: accountId)
    }
    
//    public static func businessAccount(enterprise: Enterprise,
  //                                     accountId: UUID) -> Account {
    //    return Account(tenantId: user.tenantId, accountType: AccountType.BUSINESS, ownerId: enterprise.enterpriseId, accountId: accountId)
    //}
}

public struct User {
    public let userId: UUID
    public let tenantId: UUID
    
    public init(userId: UUID,
                tenantId: UUID) {
        self.userId = userId
        self.tenantId = tenantId
    }
}

public enum AccountType {
    case PERSONAL
    case BUSINESS
}
/*data class Account internal constructor (val tenantId: UUID,
val accountType: AccountType,
val ownerId: UUID,
val accountId: UUID) {
    
    companion object {
        
        fun personalAccount(user: User,
                            accountId: UUID): Account = Account(user.tenantId, AccountType.PERSONAL, user.userId, accountId)
        
        fun businessAccount(enterprise: Enterprise,
        accountId: UUID): Account = Account(enterprise.tenantId, AccountType.BUSINESS, enterprise.enterpriseId, accountId)
    }
}
*/
