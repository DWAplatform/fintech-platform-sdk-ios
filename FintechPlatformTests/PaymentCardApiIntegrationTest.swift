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
        let hostName = "http://localhost:9000"
        let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE1MjU0Mjg2MDEsImlhdCI6MTUyNTM0MjIwMSwidGVuYW50SWQiOiJiMDQ1NmNjNC01NTc0LTQ4M2UtYjRmOS1lODg2Y2MzZmVkZmUiLCJhY2NvdW50VHlwZSI6IlBFUlNPTkFMIiwib3duZXJJZCI6ImFiODg5YjAxLTI3NDYtNDcwYS1iMWI2LTZlNWM2NjBhNWYxYiIsImFjY291bnRJZCI6IjMxMWU1NmY4LTk0OGEtNDA4MS1iNWYyLTllOTJmM2ZkNjFmYiIsImp3dFR5cGUiOiJBQ0NPVU5UIiwic2NvcGUiOlsiTElOS0VEX0NBUkQiLCJMSU5LRURfQ0FSRF9DQVNIX0lOIl19.Qu2B4i3Z5A-yN_NNBWRxFT3o-c0szASxYI5YY8Ajfu-CrpCxKBCJdYdjFwVG8Hhf6rft8GhM9eTlGdWu6veRLw"
        
        //  Set User Account Linked Card parameters
        let tenantId = "b0456cc4-5574-483e-b4f9-e886cc3fedfe"
        let userId = "ab889b01-2746-470a-b1b6-6e5c660a5f1b"
        let accountId = "311e56f8-948a-4081-b5f2-9e92f3fd61fb"
        
    
        //  Optional Idempotency
        // let idempotencyKey = "idemp1"
        
        //  create cash in API using FintechPlatformAPI instance.
        let fintechPlatform = FintechPlatformAPI.sharedInstance
        let paymentCardAPI = fintechPlatform.getPaymentCardAPI(hostName: hostName)
        
        let expectationRegisterCard = XCTestExpectation(description: "registerCard")
        let expectationGetCards = XCTestExpectation(description: "getCards")
        // create card
        var paymentCard: PaymentCardItem? = nil
        var cardsList : [PaymentCardItem]? = nil
        
        paymentCardAPI.registerCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardNumber: "1234123412341234", expiration: "0122", cvx: "123", currency: "EUR") { optPaymentCardItem, optError in

            XCTAssertNil(optError, "Error reply")
            
            XCTAssertNotNil(optPaymentCardItem, "No payment Card Item")
            paymentCard = optPaymentCardItem
            // complete with xctassert on optPaymentCardItem
            
            expectationRegisterCard.fulfill()
        }
        
        wait(for: [expectationRegisterCard], timeout: 5.0)
        
        print(paymentCard?.creditcardid)
        
        // getPaymentCard
        paymentCardAPI.getPaymentCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            XCTAssertNil(optError, "Error reply")
            XCTAssertNotNil(optList, "No payment Cards list")
            cardsList = optList
            
            XCTAssert(cardsList?.count == 1, "Card Not Registered")
            XCTAssertTrue(cardsList?[0].creditcardid == paymentCard?.creditcardid)
            
            expectationGetCards.fulfill()
        }
        
        wait(for: [expectationGetCards], timeout: 10.0)
        
        // create Card
        paymentCardAPI.registerCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardNumber: "9876987698769876", expiration: "1224", cvx: "987", currency: "EUR") { optPaymentCardItem, optError in
            
            XCTAssertNil(optError, "Error reply")
            
            XCTAssertNotNil(optPaymentCardItem, "No payment Card Item")
            // complete with xctassert on optPaymentCardItem
            expectationRegisterCard.fulfill()
        }
        
        wait(for: [expectationRegisterCard], timeout: 5.0)
        
        // getPaymentCard
        paymentCardAPI.getPaymentCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            XCTAssertNil(optError, "Error reply")
            XCTAssertNotNil(optList, "No payment Cards list")
            cardsList = optList
            
            XCTAssert(cardsList?.count == 2, "Card Not Registered")
            XCTAssertTrue(cardsList?[1].creditcardid == paymentCard?.creditcardid)
            
            expectationGetCards.fulfill()
        }
        
        wait(for: [expectationGetCards], timeout: 10.0)
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
