//
//  PaymentCardApiIntegrationTest.swift
//  FintechPlatformTests
//
//  Created by Tiziano Cappellari on 03/05/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

import XCTest
@testable import FintechPlatform

class PaymentCardApiIntegrationTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCards() {
        //  Server host parameters
        let hostName = "multibank24.com"
        let accessToken = "XXXXXXYYYYYY.....ZZZZZZ"
        
        //  Set User Account Linked Card parameters
        let tenantId = "87e4ff86-18b6-44cf-87af-af2411ab68c5"
        let userId = "08ad02e8-89fb-44b8-ab65-87eea175adc2"
        let accountId = "f0c84dbc-5d1d-4973-b212-1ac2cd34e5c3"
        
    
        //  Optional Idempotency
        // let idempotencyKey = "idemp1"
        
        //  create cash in API using FintechPlatformAPI instance.
        let fintechPlatform = FintechPlatformAPI.sharedInstance
        let paymentCardAPI = fintechPlatform.getPaymentCardAPI(hostName: hostName)
        
        let expectationRegisterCard = XCTestExpectation(description: "registerCard")
        
        // create card
        var paymentCard: PaymentCardItem? = nil
        
        paymentCardAPI.registerCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardNumber: "1234123412341234", expiration: "0122", cvx: "123", currency: "EUR") { optPaymentCardItem, optError in

            XCTAssertNil(optError, "Error reply")
            
            XCTAssertNotNil(optPaymentCardItem, "No payment Card Item")
            paymentCard = optPaymentCardItem
            // complete with xctassert on optPaymentCardItem
            
            expectationRegisterCard.fulfill()
        }
        
        wait(for: [expectationRegisterCard], timeout: 10.0)
        
        print(paymentCard?.creditcardid)
        
        // getPaymentCard
        
        // create Card
        
        // getPaymentCard
        
        // set Default
        
        // getPaymentCard
        
        // set Default
        
        // getPaymentCard
        
        // deleteCard
        
        // getPaymentCard
        
        
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
