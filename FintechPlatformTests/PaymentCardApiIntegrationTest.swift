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

extension PaymentCardItem: Equatable {
    public static func == (lhs: PaymentCardItem, rhs: PaymentCardItem) -> Bool {
        return
            lhs.cardId == rhs.cardId &&
                lhs.numberalias == rhs.numberalias &&
                lhs.expirationdate == rhs.expirationdate &&
        lhs.activestate == rhs.activestate &&
        lhs.currency == rhs.currency &&
        lhs.isDefault == rhs.isDefault
    }
}

class PaymentCardApiIntegrationTest: XCTestCase {

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
        
        /*hostName="http://localhost:9000"
    accessToken="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE1MjU1OTQyNDEsImlhdCI6MTUyNTUwNzg0MSwidGVuYW50SWQiOiJiMDQ1NmNjNC01NTc0LTQ4M2UtYjRmOS1lODg2Y2MzZmVkZmUiLCJhY2NvdW50VHlwZSI6IlBFUlNPTkFMIiwib3duZXJJZCI6Ijk0MmQ5NTg0LWU0M2UtNDFjMS04Yzg5LWUwN2EzZjQ3ZjBjNyIsImFjY291bnRJZCI6ImRiNzY2NGVlLTcyNDMtNDQ5NS1hZmU5LTlkNjQzNzEwNWUzOSIsImp3dFR5cGUiOiJBQ0NPVU5UIiwic2NvcGUiOlsiTElOS0VEX0NBUkQiLCJMSU5LRURfQ0FSRF9DQVNIX0lOIl19.YqzO2-UkbE1i6a4dG-tqPfbtoneiWfnoHFTpyzHRS16g-RaIf_dM-SiLtkdRDizm0IzZ-eu614Pdaf3B33bf8w"
        
        tenantId="b0456cc4-5574-483e-b4f9-e886cc3fedfe"
        
        userId="942d9584-e43e-41c1-8c89-e07a3f47f0c7"
        
        accountId="db7664ee-7243-4495-afe9-9d6437105e39"*/

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCards() {
        guard let hostName = hostName else { XCTFail(); return }
        guard let accessToken = accessToken else { XCTFail(); return }
        guard let tenantId = tenantId else { XCTFail(); return }
        guard let userId = userId else { XCTFail(); return }
        guard let accountId = accountId else { XCTFail(); return }
        
        //  create payment card API using FintechPlatformAPI instance.
        let paymentCardAPI = fintechPlatform.getPaymentCardAPI(hostName: hostName)
        
        
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
        
        // getPaymentCards, expect only the First Card created
        let expectationGetCards1 = XCTestExpectation(description: "getCards")
        var cardsList : [PaymentCardItem]? = nil
        var cardsListOptError: Error? = nil
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            
            cardsListOptError = optError
            cardsList = optList
            
            expectationGetCards1.fulfill()
        }
        
        wait(for: [expectationGetCards1], timeout: 600.0)
        
        XCTAssertNil(cardsListOptError, "getPaymentCards Error reply")
        XCTAssertNotNil(cardsList, "getPaymentCards No payment Cards list")
        
        XCTAssertEqual(cardsList!.count, 1, "getPaymentCards Card Not Registered")
        XCTAssert(cardsList!.contains(paymentCard1!))
        
        // create Second Card
        var paymentCard2: PaymentCardItem? = nil
        var paymentCard2OptError: Error? = nil
        let expectationRegisterCard2 = XCTestExpectation(description: "registerSecondCard")
        paymentCardAPI.registerCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardNumber: "9876987698769876", expiration: "1224", cvx: "987", currency: "EUR", idempotency: "idemp2") { optPaymentCardItem, optError in
            
            paymentCard2OptError = optError
            paymentCard2 = optPaymentCardItem
            expectationRegisterCard2.fulfill()
        }
        
        wait(for: [expectationRegisterCard2], timeout: 600.0)
        
        XCTAssertNil(paymentCard2OptError, "registerCard Error reply")
        XCTAssertNotNil(paymentCard2, "registerCard No payment Card Item")
        
        // getPaymentCards, expect two Cards
        let expectationGetCards2 = XCTestExpectation(description: "getTwoCards")
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            cardsListOptError = optError
            cardsList = optList
            
            
            
            expectationGetCards2.fulfill()
        }
        
        wait(for: [expectationGetCards2], timeout: 600.0)
        
        XCTAssertNil(cardsListOptError, "Error reply")
        XCTAssertNotNil(cardsList, "No payment Cards list")
        XCTAssertEqual(cardsList!.count, 2, "Card Not Registered")
        
        XCTAssert(cardsList!.contains(paymentCard1!))
        XCTAssert(cardsList!.contains(paymentCard2!))
        
        
        // set the First Card as Default
        let expectationDefaultCard1 = XCTestExpectation(description: "setFirstCardDefault")
        var setDefaultCard1:PaymentCardItem? = nil
        var setDefaultCard1optError:Error? = nil
        if let cardId = paymentCard1?.cardId {
            paymentCardAPI.setDefaultCard(token: accessToken, ownerId: userId, accountId: accountId, accountType: "PERSONAL", tenantId: tenantId, cardId: cardId) { (optPaymentCard, optError) in
                
                setDefaultCard1 = optPaymentCard
                setDefaultCard1optError = optError
                expectationDefaultCard1.fulfill()
            }
        }
        
        wait(for: [expectationDefaultCard1], timeout: 600.0)
        
        XCTAssertNil(setDefaultCard1optError, "Error reply")
        XCTAssertNotNil(setDefaultCard1, "No payment Cards list")
        
        let paymentCard1Default = PaymentCardItem(cardId: paymentCard1!.cardId, numberalias: paymentCard1!.numberalias, expirationdate: paymentCard1!.expirationdate, activestate: paymentCard1!.activestate, currency: paymentCard1!.currency, isDefault: true, issuer: paymentCard1!.issuer, created: paymentCard1!.created, updated: setDefaultCard1!.updated)
        XCTAssert(paymentCard1Default == setDefaultCard1, "paymentcard is not default card")
        
        XCTAssertGreaterThanOrEqual(setDefaultCard1!.updated!, paymentCard1!.updated!)
        
        // getPaymentCard, expect 2 cards, the first as default and the other not
        let expectationGetCards3 = XCTestExpectation(description: "getCardsWithDefault")
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            
            cardsListOptError = optError
            cardsList = optList
            
            
            expectationGetCards3.fulfill()
        }
        
        wait(for: [expectationGetCards3], timeout: 600.0)
        
        XCTAssertNil(cardsListOptError, "Error reply")
        XCTAssertNotNil(cardsList, "No payment Cards list")
        XCTAssertEqual(cardsList!.count, 2, "Cards Not Registered")
        
        XCTAssert(cardsList!.contains(paymentCard1Default))
        
        let paymentCard2NotDefault = PaymentCardItem(cardId: paymentCard2!.cardId, numberalias: paymentCard2!.numberalias, expirationdate: paymentCard2!.expirationdate, activestate: paymentCard2!.activestate, currency: paymentCard2!.currency, isDefault: false, issuer: paymentCard2!.issuer, created: paymentCard2!.created, updated: setDefaultCard1!.updated)
        XCTAssert(cardsList!.contains(paymentCard2NotDefault))
        
        // set the Second Card as Default
        var setDefaultCard2:PaymentCardItem? = nil
        var setDefaultCard2optError:Error? = nil
        let expectationDefaultCard2 = XCTestExpectation(description: "setSecondCardDefault")
        if let cardId = paymentCard2?.cardId {
            paymentCardAPI.setDefaultCard(token: accessToken, ownerId: userId, accountId: accountId, accountType: "PERSONAL", tenantId: tenantId, cardId: cardId) { (optPaymentCard, optError) in
                setDefaultCard2 = optPaymentCard
                setDefaultCard2optError = optError
                
                expectationDefaultCard2.fulfill()
            }
        }
        wait(for: [expectationDefaultCard2], timeout: 600.0)
        
        XCTAssertNil(setDefaultCard2optError, "Error reply")
        XCTAssertNotNil(setDefaultCard2, "No payment Cards list")
        
        let paymentCard2Default = PaymentCardItem(cardId: paymentCard2!.cardId, numberalias: paymentCard2!.numberalias, expirationdate: paymentCard2!.expirationdate, activestate: paymentCard2!.activestate, currency: paymentCard2!.currency, isDefault: true, issuer: paymentCard2!.issuer, created: paymentCard2!.created, updated: setDefaultCard2!.updated)
        XCTAssert(paymentCard2Default == setDefaultCard2, "paymentcard is not default card")
        
        // getPaymentCard, expect 2 cards, the second as default and the other not
        let expectationGetCards4 = XCTestExpectation(description: "getCardsWithAnotherDefault")
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            
            cardsListOptError = optError
            cardsList = optList
            
            expectationGetCards4.fulfill()
        }
        
        wait(for: [expectationGetCards4], timeout: 600.0)
        
        XCTAssertNil(cardsListOptError, "Error reply")
        XCTAssertNotNil(cardsList, "No payment Cards list")
        
        XCTAssertEqual(cardsList!.count, 2, "Cards Not Registered")
        
        let paymentCard1NotDefault = PaymentCardItem(cardId: paymentCard1!.cardId, numberalias: paymentCard1!.numberalias, expirationdate: paymentCard1!.expirationdate, activestate: paymentCard1!.activestate, currency: paymentCard1!.currency, isDefault: false, issuer: paymentCard1!.issuer, created: paymentCard1!.created, updated: setDefaultCard2!.updated)
        
        XCTAssert(cardsList!.contains(paymentCard1NotDefault))
        XCTAssert(cardsList!.contains(paymentCard2Default))
        
        // delete the second Card
        let expectationDeleteCard1 = XCTestExpectation(description: "DeleteSecondCard")
        var deleteCard1OptError: Error? = nil
        var deleteCard1:Bool? = nil
        if let cardId = paymentCard2?.cardId {
            paymentCardAPI.deletePaymentCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardId: cardId) { (optBool, optError) in
                deleteCard1OptError = optError
                deleteCard1 = optBool
                expectationDeleteCard1.fulfill()
            }
        }
        
        wait(for: [expectationDeleteCard1], timeout: 600.0)
        
        XCTAssertNil(deleteCard1OptError, "Error reply")
        XCTAssertNotNil(deleteCard1, "Doesn't delete payment card")
        XCTAssertTrue(deleteCard1!)
        
        // getPaymentCard, expect only the first card
        let expectationGetCards5 = XCTestExpectation(description: "getCardsAfterDeletion")
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            
            cardsListOptError = optError
            cardsList = optList
            
            expectationGetCards5.fulfill()
        }
        
        wait(for: [expectationGetCards5], timeout: 600.0)
        
        XCTAssertNil(cardsListOptError, "Error reply")
        XCTAssertNotNil(cardsList, "No payment Cards list")
        
        XCTAssertEqual(cardsList?.count, 1)
        XCTAssert(cardsList!.contains(paymentCard1NotDefault))
        
        // deleteCard the first card
        let expectationDeleteCard2 = XCTestExpectation(description: "DeleteLastCard")
        var deleteCard2OptError: Error? = nil
        var deleteCard2:Bool? = nil
        if let cardId = paymentCard1?.cardId {
            paymentCardAPI.deletePaymentCard(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL", cardId: cardId) { (optBool, optError) in
                
                deleteCard2OptError = optError
                deleteCard2 = optBool
                
                expectationDeleteCard2.fulfill()
            }
        }
        wait(for: [expectationDeleteCard2], timeout: 600.0)
        
        XCTAssertNil(deleteCard2OptError, "Error reply")
        XCTAssertNotNil(deleteCard2, "Doesn't delete payment card")
        XCTAssertTrue(deleteCard2!)
        
        // getPaymentCard, expect empty cards
        let expectationGetCards6 = XCTestExpectation(description: "getEmptyCardList")
        paymentCardAPI.getPaymentCards(token: accessToken, tenantId: tenantId, accountId: accountId, ownerId: userId, accountType: "PERSONAL") { (optList, optError) in
            
            cardsListOptError = optError
            cardsList = optList
            
            expectationGetCards6.fulfill()
        }
        
        wait(for: [expectationGetCards6], timeout: 600.0)
        
        XCTAssertNil(cardsListOptError, "Error reply")
        XCTAssertNotNil(cardsList, "No payment Cards list")
        XCTAssertEqual(cardsList?.count, 0)
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
