//
//  AccountAPI.swift
//  FintechPlatform
//
//  Created by Matteo Stefanini on 29/08/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

open class AccountAPI {
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    
    open func getPersonalAccount(token: String,
                            account: Account,
                            completion: @escaping (PersonalAccount?, Error?) -> Void) {
        
        struct Response: Codable {
            var levelStatus: String
            var level: String
        }
        
        guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(account.tenantId)/\(account.accountType.rawValue)/\(account.ownerId)/accounts/\(account.accountId)")
            else { fatalError() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
                let reply = try JSONDecoder().decode(Response.self, from: data)
                
                guard let accountLevel = AccountLevel(rawValue: reply.level), let accountLevelStatus = AccountLevelStatus(rawValue: reply.levelStatus) else {
                    completion(nil, WebserviceError.ResourseNotFound)
                    return
                }
                
                completion(PersonalAccount(account: account,
                                           accountLevel: accountLevel,
                                           accountLevelStatus: accountLevelStatus),
                           nil)
            } catch {
                completion(nil, WebserviceError.NOJSONReply)
            }
        }.resume()
    }
    
    open func updatePersonalAccount(token: String,
                               account: Account,
                               completion: @escaping (PersonalAccount?, Error?) -> Void) {
        struct Request: Codable {
            var levelStatus: AccountLevelStatus
            var status: String
        }
        
        struct Response: Codable {
            var levelStatus: AccountLevelStatus
            var level: AccountLevel
        }
        
        guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(account.tenantId)/\(account.accountType.rawValue)/\(account.ownerId)/accounts/\(account.accountId)")
            else { fatalError() }
        
        let body = Request(levelStatus: AccountLevelStatus.REQUEST_UPGRADE_TO_LEVEL2,
                           status: "ENABLED")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(body)
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
                let reply = try JSONDecoder().decode(Response.self, from: data)
                
                completion(PersonalAccount(account: account,
                                           accountLevel: reply.level,
                                           accountLevelStatus: reply.levelStatus),
                           nil)
            } catch {
                completion(nil, WebserviceError.NOJSONReply)
            }
        }.resume()
    }

}
