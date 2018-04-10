//
//  CashInResponse.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
struct CashInResponse {
    let transactionid: String
    let securecodeneeded: Bool
    let redirecturl: String?
    
    init(transactionid: String,
         securecodeneeded: Bool,
         redirecturl: String?) {
        
        self.transactionid = transactionid
        self.securecodeneeded = securecodeneeded
        self.redirecturl = redirecturl
    }
}
