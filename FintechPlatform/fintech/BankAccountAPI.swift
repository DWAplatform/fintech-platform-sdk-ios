//
//  BankAccountAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
open class BankAccountAPI {
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    
    open func createLinkedBank(token: String,
                          ownerId: String,
                          accountId: String,
                          accountType: String,
                          tenantId: String,
                          iban: String,
                          idempotency: String? = nil,
                          completion: @escaping (BankAccount?, Error?) -> Void) {
        
        do {
            guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(NetHelper.getPath(from: accountType))/\(ownerId)/accounts/\(accountId)/linkedBanks")
                else { fatalError() }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            
            jsonObject.setValue(iban, forKey: "iban")
            
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
                        options: []) as? [String:String]
                    
                    guard let ibanid = reply?["bankId"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let iban = reply?["iban"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let activestate = reply?["status"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    let ucc = BankAccount(bankaccountid: ibanid, iban: iban, activestate: activestate, accountId: accountId)
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
