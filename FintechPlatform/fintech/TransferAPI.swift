//
//  TransferAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 11/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
open class TransferAPI {
    
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    
    open func p2p(token: String,
                  from account: Account,
                  to transferAccount: TransferAccount,
                  message: String?,
                  amount: Int64,
                  idempotency: String,
                  completion: @escaping (Error?) -> Void) {
        do {
            guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(account.tenantId.uuidString)/\(NetHelper.getPath(from: account.accountType.path))/\(account.ownerId.uuidString)/accounts/\(account.accountId.uuidString)/transfers")
                else { fatalError() }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let joCredited: NSMutableDictionary = NSMutableDictionary()
            joCredited.setValue(transferAccount.creditedAccount.ownerId, forKey: "ownerId")
            joCredited.setValue(transferAccount.creditedAccount.accountId, forKey: "accountId")
            joCredited.setValue(transferAccount.creditedAccount.tenantId, forKey: "tenantId")
            joCredited.setValue(transferAccount.creditedAccount.accountType, forKey: "accountType")
            
            let joAmount: NSMutableDictionary = NSMutableDictionary()
            joAmount.setValue(amount, forKey: "amount")
            joAmount.setValue("EUR", forKey: "currency")
            
            let jo: NSMutableDictionary = NSMutableDictionary()
            jo.setValue(joCredited, forKey: "creditedAccount")
            jo.setValue(joAmount, forKey: "amount")
            if let msg = message {
                jo.setValue(msg, forKey: "message")
            }
            let jsdata = try JSONSerialization.data(withJSONObject: jo, options: JSONSerialization.WritingOptions())
            
            request.httpBody = jsdata
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.addBearerAuthorizationToken(token: token)
            
            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else { completion(error); return }
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
                        options: []) as? [String:String]
                    
                    completion(nil)
                } catch {
                    completion(error)
                }
                
                }.resume()
        } catch let error {
            completion(error)
        }
    }
    
    open func qrCredit(token: String,
                    account: Account,
                    message: String?,
                    amount: Money,
                    idempotency: String,
                    completion: @escaping (String?, Error?) -> Void) {
        
    }
    
    open func getQr(token: String,
                    qrTransferId: String,
                    tenantId: String,
                    completion: @escaping (TransferAccount?, Error?) -> Void) {
        
        guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/qrCreditTransfers/\(qrTransferId)/details")
            else { fatalError() }

        var request = URLRequest(url: url)
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
                case 403:
                    completion(nil, WebserviceError.TokenError)
                default:
                    completion(nil, NetHelper.createRequestError(data: data, error: error))
                }
                return
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(jsonResult)
                }
                let reply = try JSONDecoder().decode(TransferAccount.self, from: data)
                completion(reply, nil)
            } catch {
                print(error)
                completion(nil, error)
            }
        }.resume()
    }
}
