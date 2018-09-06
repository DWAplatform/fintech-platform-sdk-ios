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
    /**
     Link a new Bank Account using IBAN address to the Fintech Account.
     - parameters:
     - token: got from "Create User token" request.
     - tenantId: Fintech tenant id
     - accountId: Fintech Account id
     - ownerId: Fintech id of the owner of the Fintech Account
     - accountType: set if PERSONAL or BUSINESS type of account
     - iban: IBAN address of bank account to link with Fintech Account
     - idempotency: parameter to avoid multiple inserts.
     * Use [token] got from "Create User token" request.
     * Use [idempotency] parameter to avoid multiple inserts.
     * [completion] callback will be call with BankAccount object in case of success or Exception in case of errors.
     */
    open func createLinkedBank(token: String,
                               account: Account,
                               iban: String,
                               idempotency: String? = nil,
                               completion: @escaping (BankAccount?, Error?) -> Void) {
        
        do {
            guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(account.tenantId.uuidString)/\(account.accountType.path)/\(account.ownerId.uuidString)/accounts/\(account.accountId.uuidString)/linkedBanks")
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
                    
                    let ucc = BankAccount(bankaccountid: ibanid, iban: iban, activestate: activestate, accountId: account.accountId.uuidString)
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
