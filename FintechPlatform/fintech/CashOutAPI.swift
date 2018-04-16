//
//  CashOutAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
open class CashOutAPI {
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    
    /**
     * CashOut transfers money from Fintech Account, identified from [tenantId] [ownerId] [accountType] and [accountId] params, to linked bank account [linkedBankId]
     * You have to set the [amount] to transfer.
     * Use [token] got from "Create User token" request.
     * Use [idempotency] parameter to avoid multiple inserts.
     */
    open func cashOut(token: String,
                userId: String,
                accountId: String,
                accountType: String,
                tenantId: String,
                linkedBankId: String,
                amount: Int64,
                idempotency: String,
                completion: @escaping (Error?) -> Void) {
        
        let path = NetHelper.getPath(from: accountType)
        
        do {
            guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(path)/\(userId)/accounts/\(accountId)/linkedBanks/\(linkedBankId)/cashOuts")
                else { fatalError() }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            let joAmount = NSMutableDictionary()
            joAmount.setValue(amount, forKey: "amount")
            joAmount.setValue("EUR", forKey: "currency")
            
            jsonObject.setValue(joAmount, forKey: "amount")
            
            let jsdata = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
            
            request.httpBody = jsdata
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addBearerAuthorizationToken(token: token)
            
            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else { completion(nil); return }
                guard let data = data else {
                    completion(WebserviceError.DataEmptyError)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(WebserviceError.NoHTTPURLResponse)
                    return
                }
                
                if (httpResponse.statusCode != 200) {
                    switch(httpResponse.statusCode) {
                    case 409:
                        completion(WebserviceError.IdempotencyError)
                    case 401:
                        completion(WebserviceError.TokenError)
                    default:
                        completion(WebserviceError.StatusCodeNotSuccess)
                    }
                    return
                }
                
                do {
                    let _ = try JSONSerialization.jsonObject(
                        with: data,
                        options: []) as? [String:Any]
                    
                    completion(nil)
                } catch {
                    completion(error)
                }
                }.resume()
        } catch let error {
            completion(error)
        }
    }
    
    open func cashOutFee(token: String,
                   ownerId: String,
                   accountId: String,
                   accountType: String,
                   tenantId: String,
                   linkedBankId: String,
                   amount: Money,
                   idempotency: String,
                   completion: @escaping (Money?, Error?) -> Void) {
        
        let path = NetHelper.getPath(from: accountType)
        
        let url = hostName + "/rest/v1/account/tenants/\(tenantId)/\(path)/\(ownerId)/accounts/\(accountId)/linkedBanks/\(linkedBankId)/cashOutsFee"
        
        var params = Dictionary<String, String>()
        params["amount"] = amount.toString()
        params["currency"] = amount.getCurrency()
        
        guard let rurl = URL(string: NetHelper.getUrlDataString(url: url, params: params)) else { fatalError() }
        var request = URLRequest(url:  rurl)
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
