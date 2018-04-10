//
//  BalanceAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
public class BalanceAPI {
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    init(hostName: String) {
        self.hostName = hostName
    }
    
    func balance(token: String,
                 ownerId: String,
                 accountId: String,
                 tenantId: String,
                 accountType: String,
                 completion: @escaping (Money?, Error?) -> Void) {
        
        guard let url = URL(string:
            hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(NetHelper.getPath(from: accountType))/\(ownerId)/accounts/\(accountId)/balance") else { fatalError() }
        
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
                let reply = try JSONSerialization.jsonObject(
                    with: data,
                    options: []) as? [String:Any]
                
                guard let balance = reply?["balance"] as? [String: Any] else  { return }
                guard let amount = balance["amount"] as? Int64 else { completion(nil, WebserviceError.MissingMandatoryReplyParameters); return }
                let moneyBalance = Money(value: amount,
                                         currency: balance["currency"] as? String)
                
                guard let availableBalance = reply?["availableBalance"] as? [String: Any] else  { return }
                
                //                  TODO  handle availableMoney
                guard let availableAmount = availableBalance["amount"] as? Int64 else { completion(nil, WebserviceError.MissingMandatoryReplyParameters); return }
                let _ = Money(value: availableAmount,
                              currency: availableBalance["currency"] as? String)
                
                completion(moneyBalance, nil)
                
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
