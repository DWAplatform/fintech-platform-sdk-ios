//
//  PaymentCardItem.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public enum PaymentCardIssuer: String {
    case VISA
    case MASTERCARD
    case DINERS
    case MAESTRO
    case UNKNOWN
}

public enum PaymentCardStatus: String {
    case CREATED
    case VALIDATED
    case NOT_ACTIVE
    case INVALID
}

public struct PaymentCardItem {
    public let cardId: String
    public let numberalias: String
    public let expirationdate: String
    public let activestate: String
    public let currency: String
    public let isDefault: Bool?
    public let issuer: PaymentCardIssuer?
    public let status: PaymentCardStatus?
    public let created: Date?
    public let updated: Date?
    
    public init(cardId: String,
         numberalias: String,
         expirationdate: String,
         activestate: String,
         currency: String,
         isDefault: Bool?,
         issuer: PaymentCardIssuer?,
         status: PaymentCardStatus?,
         created: Date?,
         updated: Date?){
        
        self.cardId = cardId
        self.numberalias = numberalias
        self.expirationdate = expirationdate
        self.activestate = activestate
        self.currency = currency
        self.isDefault = isDefault
        self.issuer = issuer
        self.status = status
        self.created = created
        self.updated = updated
    }
}
