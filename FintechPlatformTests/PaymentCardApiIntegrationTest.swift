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

    var hostName: String = ""
    var accessToken: String = ""
    var tenantId: String = ""
    var userId: String = ""
    var accountId: String = ""
    
    let fintechPlatform = FintechPlatformAPI.sharedInstance
    
    override func setUp() {
        super.setUp()
        hostName = ProcessInfo.processInfo.environment["HOSTNAME"]!
        accessToken = ProcessInfo.processInfo.environment["ACCOUNT_TOKEN"]!
        tenantId = ProcessInfo.processInfo.environment["TENANT_ID"]!
        userId = ProcessInfo.processInfo.environment["OWNER_ID"]!
        accountId = ProcessInfo.processInfo.environment["ACCOUNT_ID"]!
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCards() {

        //  Optional Idempotency
        let idempotencyKey = "idemp1"
        
        //  create payment card API using FintechPlatformAPI instance.
        let paymentCardAPI = fintechPlatform.getPaymentCardAPI(hostName: hostName)
        
        let expectationRegisterCard1 = XCTestExpectation(description: "registerCard")
        let expectationGetCards1 = XCTestExpectation(description: "getCards")
        let expectationRegisterCard2 = XCTestExpectation(description: "registerSecondCard")
        let expectationGetCards2 = XCTestExpectation(description: "getTwoCards")
        let expectationDefaultCard1 = XCTestExpectation(description: "setFirstCardDefault")
        let expectationGetCards3 = XCTestExpectation(description: "getCardsWithDefault")
        let expectationDefaultCard2 = XCTestExpectation(description: "setSecondCardDefault")
        let expectationGetCards4 = XCTestExpectation(description: "getCardsWithAnotherDefault")
        
        let expectationDeleteCard1 = XCTestExpectation(description: "DeleteSecondCard")
        let expectationGetCards5 = XCTestExpectation(description: "getCardsAfterDeletion")
        let expectationDeleteCard2 = XCTestExpectation(description: "DeleteLastCard")
        let expectationGetCards6 = XCTestExpectation(description: "getEmptyCardList")
        // create card
        var paymentCard1: PaymentCardItem? = nil
        var paymentCard2: PaymentCardItem? = nil
        var cardsList : [PaymentCardItem]? = nil
        
        paymentCardAPI.registerCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardNumber: "1234123412341234", expiration: "0122", cvx: "123", currency: "EUR", idempotency: idempotencyKey) { optPaymentCardItem, optError in

            XCTAssertNil(optError, "Error reply")
            
            XCTAssertNotNil(optPaymentCardItem, "No payment Card Item")
            paymentCard1 = optPaymentCardItem
            // complete with xctassert on optPaymentCardItem
            
            expectationRegisterCard1.fulfill()
        }
        
        wait(for: [expectationRegisterCard1], timeout: 5.0)
        
        print(paymentCard1?.cardId)
        
        // getPaymentCard
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            XCTAssertNil(optError, "Error reply")
            XCTAssertNotNil(optList, "No payment Cards list")
            cardsList = optList
            
            XCTAssert(cardsList?.count == 1, "Card Not Registered")
            XCTAssertTrue(cardsList?[0].cardId == paymentCard1?.cardId)
            
            expectationGetCards1.fulfill()
        }
        
        wait(for: [expectationGetCards1], timeout: 5.0)
        
        // create Card
        let idempotency = "idemp2"
        paymentCardAPI.registerCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardNumber: "9876987698769876", expiration: "1224", cvx: "987", currency: "EUR", idempotency: idempotency) { optPaymentCardItem, optError in
            
            XCTAssertNil(optError, "Error reply")
            
            XCTAssertNotNil(optPaymentCardItem, "No payment Card Item")
            paymentCard2 = optPaymentCardItem
            expectationRegisterCard2.fulfill()
        }
        
        wait(for: [expectationRegisterCard2], timeout: 5.0)
        
        // getPaymentCard
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            XCTAssertNil(optError, "Error reply")
            XCTAssertNotNil(optList, "No payment Cards list")
            cardsList = optList
            
            XCTAssert(cardsList?.count == 2, "Card Not Registered")
            XCTAssertTrue(cardsList?[0].cardId == paymentCard2?.cardId)
            XCTAssertTrue(cardsList?[1].cardId == paymentCard1?.cardId)
            
            expectationGetCards2.fulfill()
        }
        
        wait(for: [expectationGetCards2], timeout: 10.0)
        
        // set Default
        if let cardId = paymentCard1?.cardId {
            paymentCardAPI.setDefaultCard(token: accessToken, ownerId: userId, accountId: accountId, accountType: "PERSONAL", tenantId: tenantId, cardId: cardId) { (optPaymentCard, optError) in
                XCTAssertNil(optError, "Error reply")
                XCTAssertNotNil(optPaymentCard, "No payment Cards list")
                XCTAssert(paymentCard1?.cardId == optPaymentCard?.cardId, "paymentcard is not default card")
                XCTAssertNotNil(optPaymentCard!.isDefault)
                XCTAssert(optPaymentCard!.isDefault!, "Card is not default")
                
                expectationDefaultCard1.fulfill()
            }
        }
        
        wait(for: [expectationDefaultCard1], timeout: 10.0)
        
        // getPaymentCard
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            XCTAssertNil(optError, "Error reply")
            XCTAssertNotNil(optList, "No payment Cards list")
            cardsList = optList
            
            XCTAssertTrue(cardsList?[1].cardId == paymentCard1?.cardId)
            XCTAssertNotNil((cardsList?[1].isDefault)!)
            XCTAssertTrue((cardsList?[1].isDefault)!)
            XCTAssertNotNil((cardsList?[0].isDefault)!)
            XCTAssertFalse((cardsList?[0].isDefault)!)
            expectationGetCards3.fulfill()
        }
        
        wait(for: [expectationGetCards3], timeout: 30.0)

        // set Default
        if let cardId = paymentCard2?.cardId {
            paymentCardAPI.setDefaultCard(token: accessToken, ownerId: userId, accountId: accountId, accountType: "PERSONAL", tenantId: tenantId, cardId: cardId) { (optPaymentCard, optError) in
                XCTAssertNil(optError, "Error reply")
                XCTAssertNotNil(optPaymentCard, "No payment Cards list")
                XCTAssert(paymentCard2?.cardId == optPaymentCard?.cardId, "paymentcard is not default card")
                XCTAssertNotNil(optPaymentCard!.isDefault)
                XCTAssert(optPaymentCard!.isDefault!, "Card is not default")
                
                expectationDefaultCard2.fulfill()
            }
        }
        wait(for: [expectationDefaultCard2], timeout: 10.0)
        
        // getPaymentCard
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            XCTAssertNil(optError, "Error reply")
            XCTAssertNotNil(optList, "No payment Cards list")
            cardsList = optList
            
            XCTAssertTrue(cardsList?[1].cardId == paymentCard1?.cardId)
            XCTAssertNotNil((cardsList?[1].isDefault)!)
            XCTAssertFalse((cardsList?[1].isDefault)!)
            XCTAssertNotNil((cardsList?[0].isDefault)!)
            XCTAssertTrue((cardsList?[0].isDefault)!)
            expectationGetCards4.fulfill()
        }
        
        wait(for: [expectationGetCards4], timeout: 10.0)
        
        // deleteCard
        if let cardId = paymentCard2?.cardId {
            paymentCardAPI.deletePaymentCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardId: cardId) { (optBool, optError) in
                XCTAssertNil(optError, "Error reply")
                XCTAssertNotNil(optBool, "Doesn't delete payment card")
                XCTAssertTrue(optBool)
                expectationDeleteCard1.fulfill()
            }
        }
        
        wait(for: [expectationDeleteCard1], timeout: 10.0)
        
        // getPaymentCard
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            XCTAssertNil(optError, "Error reply")
            XCTAssertNotNil(optList, "No payment Cards list")
            cardsList = optList
            
            XCTAssertTrue(cardsList?.count == 1)
            XCTAssertEqual(cardsList?[0].cardId, paymentCard1?.cardId)
            expectationGetCards5.fulfill()
        }
        
        wait(for: [expectationGetCards5], timeout: 10.0)
        
        // deleteCard
        if let cardId = paymentCard1?.cardId {
            paymentCardAPI.deletePaymentCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardId: cardId) { (optBool, optError) in
                XCTAssertNil(optError, "Error reply")
                XCTAssertNotNil(optBool, "Doesn't delete payment card")
                XCTAssertTrue(optBool)
                expectationDeleteCard2.fulfill()
            }
        }
        wait(for: [expectationDeleteCard2], timeout: 10.0)
        
        // getPaymentCard
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            XCTAssertNil(optError, "Error reply")
            XCTAssertNotNil(optList, "No payment Cards list")
            cardsList = optList
            
            XCTAssertTrue(cardsList?.count == 0)
            expectationGetCards6.fulfill()
        }
        
        wait(for: [expectationGetCards6], timeout: 10.0)
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
