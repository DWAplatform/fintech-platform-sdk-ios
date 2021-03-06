//
//  BalanceAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
open class BalanceAPI {
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    
    /**
     Balance represent the total amount of money that User [ownerId] has in his own Fintech Account, identified from [tenantId] [accountType] and [accountId] params.
     - parameters:
         - token: got from "Create User token" request.
         - tenantId: Fintech tenant id
         - accountId: Fintech Account id
         - ownerId: Fintech id of the owner of the Fintech Account
         - accountType: set if PERSONAL or BUSINESS type of account
         - completion: a balance item contains two variables, balance and availableBalance, or Error if error occurs
     - returns: Balance item contains two variables, balance and availableBalance
     */
    open func balance(token: String,
                      account: Account,
                      completion: @escaping (BalanceItem?, Error?) -> Void) {
        
        guard let url = URL(string:
            hostName + "/rest/v1/fintech/tenants/\(account.tenantId.uuidString)/\(account.accountType.path)/\(account.ownerId.uuidString)/accounts/\(account.accountId.uuidString)/balance") else { fatalError() }
        
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
                completion(nil, WebserviceError.StatusCodeNotSuccess)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BalanceItem.self, from: data)
                completion(response, nil)
                
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
