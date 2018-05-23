//
//  TransactionsAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
open class TransactionsAPI {
    
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    
    /**
    Get all transactions (cash in, cash out, purchases) of the Fintech Account selected.
     - parameters:
         - token: got from "Create User token" request.
         - tenantId: Fintech tenant id
         - accountId: Fintech Account id
         - ownerId: Fintech id of the owner of the Fintech Account
         - accountType: set if PERSONAL or BUSINESS type of account
         - limit: the list of transactions will have a maximum length based on this paramenter, (default 5, max 100).
         - offset: handles range of transactions to get.
     - returns: TransactionResponse is a detailed model of transactions parameters.
     */
    open func transactions(token: String,
                      ownerId: String,
                      accountId: String,
                      accountType: String,
                      tenantId: String,
                      limit: Int?=nil,
                      offset: Int?=nil,
                      completion: @escaping ([TransactionResponse]?, Error?) -> Void) {
        
        var optUrl : URL?
        if let limit = limit , let offset = offset {
            let query = "?limit=\(limit)&offset=\(offset)"
            optUrl = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(NetHelper.getPath(from: AccountType(rawValue: accountType)!))/\(ownerId)/accounts/\(accountId)/transactionsDetailed\(query)")
        } else {
            optUrl = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(NetHelper.getPath(from: AccountType(rawValue: accountType)!))/\(ownerId)/accounts/\(accountId)/transactionsDetailed")
        }
        
        guard let url =  optUrl else { fatalError() }
        
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
                case 401:
                    completion(nil, WebserviceError.TokenError)
                default:
                    completion(nil, WebserviceError.StatusCodeNotSuccess)
                }
                return
            }
            
            do {
                
                let optreplyArray = try JSONSerialization.jsonObject(
                    with: data,
                    options: []) as? [[String:Any]]
                
                var transactions = [TransactionResponse]()
                
                guard let replyArray = optreplyArray else {
                    completion(nil, WebserviceError.NOJSONReply)
                    return
                }
                
                for joReply in replyArray {
                    
                    guard let transactionId = joReply["transactionId"] as? String else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let status = joReply["status"] as? String else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let operationType = joReply["transactionType"] as? String else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    guard let creationDate = joReply["created"] as? String else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    let credited = joReply["credited"] as? [String:Any]
                    var fullCreditedName : String?
                    
                    if let name  = credited?["name"] as? String,   let surname = credited?["surname"]  as? String {
                        fullCreditedName = name + " " + surname
                    }
                    
                    let debited = joReply["debited"] as? [String:Any]
                    var fullDebitedName : String?
                    
                    if let nameD  = debited?["name"] as? String, let surnameD = debited?["surname"] as? String  {
                        fullDebitedName = nameD + " " + surnameD
                    }
                    
                    let amount = joReply["amount"] as? [String:Any]
                    
                    let error = joReply["error"] as? [String:Any]
                    
                    let transaction = TransactionResponse(transactionId: transactionId,
                                                          accountId: accountId,
                                                          status: status,
                                                          operationtype: operationType,
                                                          creationdate: creationDate,
                                                          creditedid: credited?["ownerId"] as? String,
                                                          debitedId: debited?["ownerId"] as? String,
                                                          creditedFunds: amount?["amount"] as? Int64,
                                                          debitedFunds: amount?["amount"] as? Int64,
                                                          creditedName: fullCreditedName,
                                                          debitedName: fullDebitedName,
                                                          creditedPhoto: credited?["picture"] as? String,
                                                          debitedPhoto: debited?["picture"] as? String,
                                                          error: error?["message"] as? String,
                                                          message: joReply["message"] as? String)
                    
                    transactions.append(transaction)
                }
                completion(transactions, nil)
            } catch {
                completion(nil, error)
            }
            }.resume()
    }
}
