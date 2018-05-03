//
//  PaymentCardItem.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
public struct PaymentCardItem {
    public let cardId: String
    public let numberalias: String
    public let expirationdate: String
    public let activestate: String
    public let currency: String
    public let isDefault: Bool?
    
    public init(cardId: String,
         numberalias: String,
         expirationdate: String,
         activestate: String,
         currency: String,
         isDefault: Bool?){
        
        self.cardId = cardId
        self.numberalias = numberalias
        self.expirationdate = expirationdate
        self.activestate = activestate
        self.currency = currency
        self.isDefault = isDefault
    }
}
