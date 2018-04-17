//
//  PaymentCardAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
open class PaymentCardAPI {
    
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    /**
     Register a Card. Use this method to register a user card and PLEASE DO NOT save card information on your own client or server side-parameters
     
     - parameters:
        - token: got from "Create User token" request.
        - tenantId: Fintech tenant id
        - accountId: Fintech Account id
        - ownerId: Fintech id of the owner of the Fintech Account
        - accountType: set if PERSONAL or BUSINESS type of account
        - cardNumber: 16 digits user card number, without spaces or dashes
        - expiration: card expiration date in MMYY format
        - cvx: 3 digit cxv card number
        - currency: actual currency of the card operations
     - Returns: PaymentCardItem with his own id, and alias card number.
     */
    open func registerCard(token: String,
                           tenantId: String,
                           accountId: String,
                           ownerId: String,
                           accountType: String,
                           cardNumber: String,
                           expiration: String,
                           cvx: String,
                           currency: String,
                           completion: @escaping (PaymentCardItem?, Error?) -> Void ){
        
        self.createCreditCardRegistration(with: ownerId, accountId: accountId, tenantId: tenantId, accountType: accountType, numberalias: CardHelper.generateAlias(cardNumber: cardNumber), expiration: expiration, currency: currency, token: token) { (optCardRegistration, optError) in
            if let error = optError { completion(nil, error); return }
            if let cardRegistration = optCardRegistration {
                self.getCardSafe(with: CardToRegister(cardNumber: cardNumber, expiration: expiration, cvx: cvx), ownerId: ownerId, accountId: accountId, tenantId: tenantId, accountType: accountType, token: token) { (optCardToReg, optError) in
                    if let error = optError { completion(nil, error); return }
                    if let cardToReg = optCardToReg {
                        self.postCardRegistrationData(with: ownerId, accountId: accountId, tenantId: tenantId, accountType: accountType, cardnumber: cardToReg.cardNumber, expiration: cardToReg.expiration, cxv: cardToReg.cxv, cardRegistration: cardRegistration, token: token, completion: { (optPaymentCardItem, optError) in
                            if let error = optError { completion(nil, error) }
                            if let paymentCard = optPaymentCardItem {
                                completion(paymentCard, nil)
                            }
                        })
                    }
                }
            }
        }
    }
    /**
     Get all Payment Cards linked to Fintech Platform Account.

     - parameters:
         - token: got from "Create User token" request.
         - tenantId: Fintech tenant id
         - accountId: Fintech Account id
         - ownerId: Fintech id of the owner of the Fintech Account
         - accountType: set if PERSONAL or BUSINESS type of account
         - completion: ist of cards or an Exception if occurent some errors
     - return: completion callback returns the list of cards or an Exception if occurent some errors
     */
    open func getPaymentCard(token: String,
                             tenantId: String,
                             accountId: String,
                             ownerId: String,
                             accountType: String,
                             completion: @escaping ([PaymentCardItem]?, Error?) -> Void) {
        let path = NetHelper.getPath(from: accountType)
        guard let baseUrl = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(path)/\(ownerId)/accounts/\(accountId)/linkedCards") else { fatalError() }
        
//        var params = Dictionary<String, String>()
//        params["userid"] = ownerId
//
//        guard let rurl = URL(string: NetHelper.getUrlDataString(url: baseUrl, params: params)) else { fatalError() }
        var request = URLRequest(url:  baseUrl)
        request.httpMethod = "GET"
        request.addBearerAuthorizationToken(token: token)
        
        session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { completion(nil, error); return }
            
            guard let data = data else {
                completion(nil, WebserviceError.DataEmptyError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, WebserviceError.NoHTTPURLResponse)
                return
            }
            
            if (httpResponse.statusCode != 200) {
                completion(nil, WebserviceError.StatusCodeNotSuccess)
                return
            }
            
            do {
                let reply = try JSONSerialization.jsonObject(
                    with: data,
                    options: []) as? [[String:Any]]
                guard let cardlist = reply else { completion(nil, nil); return}
                var paymentCardsList = [PaymentCardItem]()
                for card in cardlist {
                    guard let alias = card["alias"] as? String else { completion(nil, WebserviceError.MissingMandatoryReplyParameters); return}
                    guard let expiration = card["expiration"] as? String else { completion(nil, WebserviceError.MissingMandatoryReplyParameters); return}
                    guard let currency = card["currency"] as? String else { completion(nil, WebserviceError.MissingMandatoryReplyParameters); return}
                    guard let activestate = card["status"] as? String else { completion(nil, WebserviceError.MissingMandatoryReplyParameters); return}
                    guard let cardId = card["cardId"] as? String else { completion(nil, WebserviceError.MissingMandatoryReplyParameters); return}
                    
                    paymentCardsList.append(PaymentCardItem(creditcardid: cardId, numberalias: alias, expirationdate: expiration, activestate: activestate, currency: currency))
                }
                completion(paymentCardsList, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    private func createCreditCardRegistration(with ownerId: String,
                                              accountId: String,
                                              tenantId: String,
                                              accountType: String,
                                              numberalias: String,
                                              expiration: String,
                                              currency: String,
                                              token: String,
                                              completion: @escaping (CardRegistration?, Error?) -> Void) {
        
        
        do {
            guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(NetHelper.getPath(from: accountType))/\(ownerId)/accounts/\(accountId)/linkedCards")
                else { fatalError() }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            
            jsonObject.setValue(numberalias, forKey: "alias")
            jsonObject.setValue(expiration, forKey: "expiration")
            jsonObject.setValue(currency, forKey: "currency")
            
            let jsdata = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
            
            request.httpBody = jsdata
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addBearerAuthorizationToken(token: token)
            
            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else { completion(nil, error); return }
                
                guard let data = data else {
                    completion(nil, WebserviceError.DataEmptyError)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, WebserviceError.NoHTTPURLResponse)
                    return
                }
                
                if (httpResponse.statusCode != 200) {
                    completion(nil, WebserviceError.StatusCodeNotSuccess)
                    return
                }
                
                do {
                    
                    let reply = try JSONSerialization.jsonObject(
                        with: data,
                        options: []) as? [String:Any]
                    
                    guard let anycreditcardid = reply?["cardId"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    guard let creditcardid = anycreditcardid as? String else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let anycardRegistrationObj = reply?["tspPayload"] as? String else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    let mapper = try JSONSerialization.jsonObject(
                        with: anycardRegistrationObj.data(using: String.Encoding.utf8)!,
                        options: [] ) as? [String:String]
                    guard let preregistrationData = mapper?["preregistrationData"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let accessKey = mapper?["accessKey"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let url = mapper?["url"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    let ucc = CardRegistration(url: url, usercardid: creditcardid, preregistrationData: preregistrationData, accessKey: accessKey)
                    completion(ucc, nil)
                } catch {
                    completion(nil, error)
                }
                
                
                }.resume()
        } catch let error {
            completion(nil, error)
        }
    }
    
    private func getCardSafe(with cardToRegister: CardToRegister,
                             ownerId: String,
                             accountId: String,
                             tenantId: String,
                             accountType: String,
                             token: String,
                             completion: @escaping (CardToRegister?, Error?) -> Void) {

        guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(NetHelper.getPath(from: accountType))/\(ownerId)/accounts/\(accountId)/linkedCardsTestCards")
            else { fatalError() }
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addBearerAuthorizationToken(token: token)
        
        session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { completion(nil, error); return }
            
            guard let data = data else {
                completion(nil, WebserviceError.DataEmptyError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, WebserviceError.NoHTTPURLResponse)
                return
            }
            
            if (httpResponse.statusCode != 200) {
                completion(nil, WebserviceError.StatusCodeNotSuccess)
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]]
                guard let joResponse = response else {
                    completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                    return
                }
                let jo = joResponse[0]
                guard let cardNumb = jo["cardNumber"] else {
                    completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                    return
                }
                guard let exp = jo["expiration"] else {
                    completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                    return
                }
                guard let cxv = jo["cxv"] else {
                    completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                    return
                }
                
                let card = CardToRegister(cardNumber: cardNumb, expiration: exp, cvx: cxv)
                completion(card, nil)
                
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    
    private func postCardRegistrationData(with ownerId: String,
                                          accountId: String,
                                          tenantId: String,
                                          accountType: String,
                                          cardnumber: String,
                                          expiration: String,
                                          cxv: String,
                                          cardRegistration: CardRegistration,
                                          token: String,
                                          completion: @escaping (PaymentCardItem?, Error?) -> Void) {
        
        let data = "data=\(cardRegistration.preregistrationData)&accessKeyRef=\(cardRegistration.accessKey)&cardNumber=\(cardnumber)&cardExpirationDate=\(expiration)&cardCvx=\(cxv)"
        
        print("postCardRegistrationData data=\(data)")
        
        
        guard let url = URL(string: cardRegistration.url)
            else { fatalError() }
        
        print("postCardRegistrationData url=\(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data.data(using: .utf8)
        
        session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { completion(nil, error); return }
            
            guard let data = data else {
                completion(nil, WebserviceError.DataEmptyError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, WebserviceError.NoHTTPURLResponse)
                return
            }
            
            if (httpResponse.statusCode != 200) {
                completion(nil, WebserviceError.StatusCodeNotSuccess)
                return
            }
            
            guard let responseString = String(data: data, encoding: .utf8) else {
                completion(nil, WebserviceError.DataEmptyError)
                return
            }
            
            self.sendCardResponseString(with: ownerId, accountId: accountId, tenantId: tenantId, accountType: accountType, responseString: responseString, cardRegistration: cardRegistration, token: token, completion: completion)
            
            }.resume()
    }
    
    
    private func sendCardResponseString(with ownerId: String,
                                        accountId: String,
                                        tenantId: String,
                                        accountType: String,
                                        responseString: String,
                                        cardRegistration: CardRegistration,
                                        token: String,
                                        completion: @escaping (PaymentCardItem?, Error?) -> Void) {
        
        do {
            guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(NetHelper.getPath(from: accountType))/\(ownerId)/accounts/\(accountId)/linkedCards/\(cardRegistration.usercardid)")
                else { fatalError() }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            jsonObject.setValue(responseString, forKey: "registration")
            jsonObject.setValue(cardRegistration.accessKey, forKey: "accessKey")
            jsonObject.setValue(cardRegistration.usercardid, forKey: "cardRegistrationId")
            jsonObject.setValue(cardRegistration.preregistrationData, forKey: "preregistrationData")
            jsonObject.setValue(cardRegistration.url, forKey: "url")
            
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            let tspPayload : NSMutableDictionary = NSMutableDictionary()
            tspPayload.setValue(String(data: jsonData, encoding: .utf8) , forKey: "tspPayload")
            
            let jsdata = try JSONSerialization.data(withJSONObject: tspPayload, options: JSONSerialization.WritingOptions())
            
            request.httpBody = jsdata
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.addBearerAuthorizationToken(token: token)
            
            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else { completion(nil, error); return }
                
                guard let data = data else {
                    completion(nil, WebserviceError.DataEmptyError)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, WebserviceError.NoHTTPURLResponse)
                    return
                }
                
                if (httpResponse.statusCode != 200) {
                    completion(nil, WebserviceError.StatusCodeNotSuccess)
                    return
                }
                
                do {
                    let reply = try JSONSerialization.jsonObject(
                        with: data,
                        options: []) as? [String:String]
                    
                    guard let creditcardid = reply?["cardId"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let numberalias = reply?["alias"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let expirationdate = reply?["expiration"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let activestate = reply?["status"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let currency = reply?["currency"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    let ucc = PaymentCardItem(creditcardid: creditcardid, numberalias: numberalias, expirationdate: expirationdate, activestate: activestate, currency: currency)
                    
                    completion(ucc, nil)
                } catch {
                    completion(nil, error)
                }
                }.resume()
        } catch let error {
            completion(nil, error)
        }
    }
    
}

struct CardRegistration {
    var url: String
    var usercardid: String
    var preregistrationData: String
    var accessKey: String
    
    init(url: String, usercardid: String, preregistrationData: String, accessKey: String) {
        self.url = url
        self.usercardid = usercardid
        self.preregistrationData = preregistrationData
        self.accessKey = accessKey
    }
}

struct CardToRegister {
    var cardNumber: String
    var expiration: String
    var cxv: String
    
    init(cardNumber: String,
         expiration: String,
         cvx: String) {
        self.cardNumber = cardNumber
        self.expiration = expiration
        self.cxv = cvx
    }
}

