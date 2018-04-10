//
//  PaymentCardItem.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
struct PaymentCardItem {
    let creditcardid: String
    let numberalias: String
    let expirationdate: String
    let activestate: String
    let currency: String
    
    init(creditcardid: String,
         numberalias: String,
         expirationdate: String,
         activestate: String,
         currency: String){
        
        self.creditcardid = creditcardid
        self.numberalias = numberalias
        self.expirationdate = expirationdate
        self.activestate = activestate
        self.currency = currency
    }
}
