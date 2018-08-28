//
//  Account.swift
//  FintechPlatform
//
//  Created by ingrid on 22/08/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public class Account {
    let tenantId: UUID
    let accountType: AccountType
    let ownerId: UUID
    let accountId: UUID
    
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
    
    public static func businessAccount(enterprise: Enterprise,
                                       accountId: UUID) -> Account {
        return Account(tenantId: enterprise.tenantId, accountType: AccountType.BUSINESS, ownerId: enterprise.enterpriseId, accountId: accountId)
    }
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

public enum AccountType: String {
    case PERSONAL = "PERSONAL"
    case BUSINESS = "BUSINESS"
}

public struct Enterprise {
    public let enterpriseId: UUID
    public let tenantId: UUID
    
    public init(enterpriseId: UUID, tenantId: UUID) {
        self.enterpriseId = enterpriseId
        self.tenantId = tenantId
    }
}
