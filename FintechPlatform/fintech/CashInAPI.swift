//
//  CashInAPi.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

open class CashInAPI {
    
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    
    /**
     * CashIn transfers money from Linked Card to the Fintech Account.
     - parameters:
         - token: got from "Create User token" request.
         - tenantId: Fintech tenant id
         - accountId: Fintech Account id
         - ownerId: Fintech id of the owner of the Fintech Account
         - accountType: set if PERSONAL or BUSINESS type of account
         - cardId: unique Id of payment card linked to Fintech Account
         - amount: amount of money to transfer from payment card to Fintech Account
         - idempotency: parameter to avoid multiple inserts.
     */
    open func cashIn(token: String,
                       ownerId: String,
                       accountId: String,
                       accountType: String,
                       tenantId: String,
                       cardId: String,
                       amount: Money,
                       idempotency: String,
                       completion: @escaping (CashInResponse?, Error?) -> Void) {
        
        let path = NetHelper.getPath(from: accountType)
        do {
            guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(path)/\(ownerId)/accounts/\(accountId)/linkedCards/\(cardId)/cashIns")
                else { fatalError() }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            
            let joAmount : NSMutableDictionary = NSMutableDictionary()
            joAmount.setValue(amount.getLongvalue(), forKey: "amount")
            joAmount.setValue(amount.getCurrency(), forKey: "currency")
            
            let joFee : NSMutableDictionary = NSMutableDictionary()
            joFee.setValue(0, forKey: "amount")
            joFee.setValue("EUR", forKey: "currency")
            
            jsonObject.setValue(joAmount, forKey: "amount")
            jsonObject.setValue(joFee, forKey: "fee")
            jsonObject.setValue(idempotency, forKey: "idempotency")
            
            let jsdata = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
            
            request.httpBody = jsdata
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.addBearerAuthorizationToken(token: token)
            
            session.dataTask(with: request) { (data, response, error) in
                if let error = error { completion(nil, error); return }
                guard let data = data else {
                    completion(nil, WebserviceError.DataEmptyError)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, WebserviceError.NoHTTPURLResponse)
                    return
                }
                
                if (httpResponse.statusCode != 200) {
                    completion(nil, NetHelper.createRequestError(data: data, error: error))
                    return
                }
            
                do {
                    let reply = try JSONSerialization.jsonObject(
                        with: data,
                        options: []) as? [String:Any]
                    
                    guard let anytransactionid = reply?["transactionId"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    guard let transactionid = anytransactionid as? String else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let anysecurecodeneeded = reply?["secure3D"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    guard let securecodeneeded = anysecurecodeneeded as? Bool else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    guard let status = reply?["status"] as? String else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    if (CashInStatus(rawValue: status)! == .FAILED) {
                        if let errorObj = reply?["error"] as? [String:String] {
                            if let code = errorObj["code"], let message = errorObj["message"] {
                                
                                var errorsList = [ServerError]()
                                if let errorCode = ErrorCode(rawValue: code){
                                    errorsList.append(ServerError(code: errorCode, message: message))
                                } else {
                                    errorsList.append(ServerError(code: ErrorCode.unknown_error, message: message))
                                }
                                
                                completion(nil, WebserviceError.APIResponseError(serverErrors: errorsList, error: error))
                                return
                            }
                        }
                    }
                    
                    let optredirecturl: String?
                    if let redirecturl = reply?["redirectURL"] {
                        optredirecturl = redirecturl as? String
                    } else {
                        optredirecturl = nil
                    }
                    
                    let created: Date?
                    if let createdStr = reply?["created"] as? String {
                        let dtc = DateTimeConversion()
                        created = dtc.convertFromRFC3339ToDate(str: createdStr)
                    } else {
                        created = nil
                    }
                    
                    let updated: Date?
                    if let updatedStr = reply?["updated"] as? String {
                        let dtc = DateTimeConversion()
                        updated = dtc.convertFromRFC3339ToDate(str: updatedStr)
                    } else {
                        updated = nil
                    }
                
                    let payinreply = CashInResponse(transactionid: transactionid, securecodeneeded: securecodeneeded, redirecturl: optredirecturl, status: CashInStatus(rawValue: status)!, created: created, updated: updated)
                    
                    completion(payinreply, nil)
                } catch {
                    completion(nil, WebserviceError.NOJSONReply)
                }
                
            }.resume()
        } catch let error {
            completion(nil, error)
        }
    }
    
    /**
    Gets Fee from amount to cash into Fintech Account.
     - parameters:
         - token: got from "Create User token" request.
         - tenantId: Fintech tenant id
         - accountId: Fintech Account id
         - ownerId: Fintech id of the owner of the Fintech Account
         - accountType: set if PERSONAL or BUSINESS type of account
         - cardId: unique Id of payment card linked to Fintech Account
         - amount: amount of money to transfer from Fintech Account to bank account
     */
    open func cashInFee(token: String,
                        tenantId: String,
                        accountId: String,
                        ownerId: String,
                        accountType: String,
                        cardId: String,
                        amount: Money,
                        completion: @escaping (Money?, Error?) -> Void) {
        
        let path = NetHelper.getPath(from: accountType)
        let query = "?amount=\(amount.getValue())&currency=\(amount.getCurrency())"
        guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(path)/\(ownerId)/accounts/\(accountId)/linkedCards/\(cardId)/cashInsFee\(query)") else { fatalError() }

        var request = URLRequest(url: url)
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
                    options: []) as? [String:Any]
                
                guard let amount = reply?["amount"] as? Int64 else { completion(nil, WebserviceError.MissingMandatoryReplyParameters); return }
                guard let currency = reply?["currency"] as? String else { completion(nil, WebserviceError.MissingMandatoryReplyParameters); return }

                let moneyFee = Money(value: amount, currency: currency)
                completion(moneyFee, nil)
                
            } catch {
                completion(nil, error)
            }
        }.resume()
    }

}


