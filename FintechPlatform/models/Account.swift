//
//  Account.swift
//  FintechPlatform
//
//  Created by ingrid on 23/05/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
public class Account {
    let tenantId: UUID
    let accountType: AccountType
    let ownerId: UUID
    let accountId: UUID
    
    init(_ tenantId: UUID,
         _ accountType: AccountType,
         _ ownerId: UUID,
         _ accountId: UUID) {
        self.tenantId = tenantId
        self.accountType = accountType
        self.ownerId = ownerId
        self.accountId = accountId
    }
    
    static func personalAccount(user: User, accountId: UUID) -> Account {
        return Account(user.tenantId, AccountType.PERSONAL, user.userId, accountId)
    }
    
    static func businessAccount(enterprise: Enterprise, accountId: UUID) -> Account {
        return Account(enterprise.tenantId, AccountType.BUSINESS, enterprise.enterpriseId, accountId)
    }
}

public enum AccountType : String {
    case PERSONAL
    case BUSINESS
}

public struct User {
    public let userId: UUID
    public let tenantId: UUID
    init(userId: UUID, tenantId: UUID) {
        self.userId = userId
        self.tenantId = tenantId
    }
}

public struct Enterprise {
    public let enterpriseId: UUID
    public let tenantId: UUID
    init(enterpriseId: UUID, tenantId: UUID) {
        self.enterpriseId = enterpriseId
        self.tenantId = tenantId
    }
}
