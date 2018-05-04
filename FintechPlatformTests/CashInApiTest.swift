//
//  CashInApiTest.swift
//  FintechPlatformTests
//
//  Created by ingrid on 04/05/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
import XCTest
@testable import FintechPlatform

class CashInApiTest: XCTestCase {
    
    let fintechAPI = FintechPlatformAPI.sharedInstance
    
    override func setUp() {
        
    }
    
    func testIdempotencyCashIn() {
        let cashInAPI = fintechAPI.getCashInAPI(hostName: "10.0.0.9:9000")
//        cashInAPI.cashIn(token: <#T##String#>, ownerId: <#T##String#>, accountId: <#T##String#>, accountType: <#T##String#>, tenantId: <#T##String#>, cardId: <#T##String#>, amount: <#T##Money#>, idempotency: <#T##String?#>, completion: <#T##(CashInResponse?, Error?) -> Void#>)
    }
}
