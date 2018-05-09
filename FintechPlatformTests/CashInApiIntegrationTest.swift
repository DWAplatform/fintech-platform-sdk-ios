//
//  CashInApiIntegrationTest.swift
//  FintechPlatformTests
//
//  Created by Tiziano Cappellari on 07/05/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

import XCTest
@testable import FintechPlatform

class CashInApiIntegrationTest: XCTestCase {
    
    var hostName: String? = nil
    var accessToken: String? = nil
    var tenantId: String? = nil
    var userId: String? = nil
    var accountId: String? = nil
    
    let fintechPlatform = FintechPlatformAPI.sharedInstance
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        hostName = ProcessInfo.processInfo.environment["HOSTNAME"]!
        accessToken = ProcessInfo.processInfo.environment["ACCOUNT_TOKEN"]!
        tenantId = ProcessInfo.processInfo.environment["TENANT_ID"]!
        userId = ProcessInfo.processInfo.environment["OWNER_ID"]!
        accountId = ProcessInfo.processInfo.environment["ACCOUNT_ID"]!

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCards() {
        guard let hostName = hostName else { XCTFail(); return }
        guard let accessToken = accessToken else { XCTFail(); return }
        guard let tenantId = tenantId else { XCTFail(); return }
        guard let userId = userId else { XCTFail(); return }
        guard let accountId = accountId else { XCTFail(); return }
        
        //  create payment card API using FintechPlatformAPI instance.
        let paymentCardAPI = fintechPlatform.getPaymentCardAPI(hostName: hostName, isSanbox: true)
        
        
        // create First Card
        var paymentCard1: PaymentCardItem? = nil
        var paymentCard1OptError: Error? = nil
        let expectationRegisterCard1 = XCTestExpectation(description: "registerCard")
        paymentCardAPI.registerCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardNumber: "1234123412341234", expiration: "0122", cvx: "123", currency: "EUR", idempotency: "idemp1") { optPaymentCardItem, optError in
            
            paymentCard1OptError = optError
            paymentCard1 = optPaymentCardItem
            expectationRegisterCard1.fulfill()
        }
        
        wait(for: [expectationRegisterCard1], timeout: 600.0)
        
        XCTAssertNil(paymentCard1OptError, "registerCard Error reply")
        XCTAssertNotNil(paymentCard1, "registerCard No payment Card Item")
        
        // cashInFee
        let expectationCashInFee = XCTestExpectation(description: "CashIn Fee")
        var cashIn1FeeOptError: Error? = nil
        var cashIn1Fee: Money? = nil
        
        let cashInAPI = fintechPlatform.getCashInAPI(hostName: hostName)
        cashInAPI.cashInFee(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardId: paymentCard1!.cardId, amount: Money(value: 1000)) { optCashInResponse, optError in
            cashIn1FeeOptError = optError
            cashIn1Fee = optCashInResponse
            
            expectationCashInFee.fulfill()
        }
        
        wait(for: [expectationCashInFee], timeout: 600.0)
        
        XCTAssertNil(cashIn1FeeOptError, "CashInFee Error reply")
        XCTAssertNotNil(cashIn1Fee, "CashIn No Fee In Response")
        
        XCTAssertEqual(cashIn1Fee!.getCurrency(), "EUR")
        XCTAssertGreaterThanOrEqual(cashIn1Fee!.getLongvalue(), 0)
        
        // cashIn without 3d secure
        let expectationCashIn1 = XCTestExpectation(description: "CashIn")
        var cashIn1OptError1: Error? = nil
        var cashIn1: CashInResponse? = nil
        
        cashInAPI.cashIn(token: accessToken, ownerId: userId, accountId: accountId, accountType: "PERSONAL", tenantId: tenantId, cardId: paymentCard1!.cardId, amount: Money(value: 1000), idempotency: "IdempCashIn") { optCashInResponse, optError in
            cashIn1OptError1 = optError
            cashIn1 = optCashInResponse
            
            expectationCashIn1.fulfill()
        }
        
        wait(for: [expectationCashIn1], timeout: 600.0)
        
        XCTAssertNil(cashIn1OptError1, "CashInFee Error reply")
        XCTAssertNotNil(cashIn1, "CashIn No Fee In Response")
        XCTAssertFalse(cashIn1!.securecodeneeded)
        XCTAssertEqual(cashIn1?.status, CashInStatus.SUCCEEDED)
        
        // cashIn with 3d secure
        let expectationCashIn2 = XCTestExpectation(description: "CashIn")
        var cashIn1OptError2: Error? = nil
        var cashIn2: CashInResponse? = nil
        
        cashInAPI.cashIn(token: accessToken, ownerId: userId, accountId: accountId, accountType: "PERSONAL", tenantId: tenantId, cardId: paymentCard1!.cardId, amount: Money(value: 10000), idempotency: "IdempCashIn") { optCashInResponse, optError in
            cashIn1OptError2 = optError
            cashIn2 = optCashInResponse
            
            expectationCashIn2.fulfill()
        }
        
        wait(for: [expectationCashIn2], timeout: 600.0)
        
        XCTAssertNil(cashIn1OptError2, "CashInFee Error reply")
        XCTAssertNotNil(cashIn2, "CashIn No Fee In Response")
        XCTAssertTrue(cashIn2!.securecodeneeded)
        XCTAssertEqual(cashIn2?.status, CashInStatus.CREATED)
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
