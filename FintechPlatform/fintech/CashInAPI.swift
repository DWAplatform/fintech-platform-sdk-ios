//
//  CashInAPi.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public class CashInAPI {
    
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    init(hostName: String) {
        self.hostName = hostName
    }
    
    /**
     * cashIn transfers money from Linked Card [cardId] to the Fintech Account, identified from [tenantId] [ownerId] [accountType] and [accountId] params.
     * You have to set the amount and currency to transfer, both to set into [amount] param.
     * Use [token] got from "Create User token" request.
     * Use [idempotency] parameter to avoid multiple inserts.
     * [completion] callback contains transactionId. Check if the Card issuer requires to perform a Secure3D procedure.
     * Whether secure3D is required, you will find the specific redirect URL.
     */
    func cashIn(token: String,
               userId: String,
               accountId: String,
               accountType: String,
               tenantId: String,
               cardId: String,
               amount: Money,
               idempotency: String,
               completion: @escaping (CashInResponse?, Error?) -> Void) {
        
        let path = NetHelper.getPath(from: accountType)
        do {
            guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(path)/\(userId)/accounts/\(accountId)/linkedCards/\(cardId)/cashIns")
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
                    switch(httpResponse.statusCode) {
                    case 409:
                        completion(nil, WebserviceError.IdempotencyError)
                    case 401:
                        completion(nil, WebserviceError.TokenError)
                    default:
                        completion(nil, WebserviceError.StatusCodeNotSuccess)
                    }
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
                    
                    let optredirecturl: String?
                    if let redirecturl = reply?["redirectURL"] {
                        optredirecturl = redirecturl as? String
                    } else {
                        optredirecturl = nil
                    }
                    
                    let payinreply = CashInResponse(transactionid: transactionid, securecodeneeded: securecodeneeded, redirecturl: optredirecturl)
                    
                    completion(payinreply, nil)
                } catch {
                    completion(nil, error)
                }
                
                }.resume()
        } catch let error {
            completion(nil, error)
        }
    }

}


