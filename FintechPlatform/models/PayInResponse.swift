//
//  CashInResponse.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
public enum PayInStatus: String {
    case REQUEST
    case CREATED
    case SUCCEEDED
    case FAILED
}

public struct PayInResponse {
    public let transactionid: String
    public let securecodeneeded: Bool
    public let redirecturl: String?
    public let status: PayInStatus
    public let created: Date?
    public let updated: Date?
    
    public init(transactionid: String,
         securecodeneeded: Bool,
         redirecturl: String?,
         status: PayInStatus,
         created: Date?,
         updated: Date?) {
        
        self.transactionid = transactionid
        self.securecodeneeded = securecodeneeded
        self.redirecturl = redirecturl
        self.status = status
        self.created = created
        self.updated = updated
    }
}
