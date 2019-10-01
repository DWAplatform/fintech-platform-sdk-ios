//
//  EnterpriseAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 01/10/2019.
//  Copyright © 2019 Fintech Platform. All rights reserved.
//

import Foundation
open class EnterpriseAPI {
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    
    /**
    Company informations.
    - parameters:
        - token: got from "Create User token" request.
        - enterprise: Fintech company object with unique ids of the tenant and the company itself.
    - returns: EnterpriseProfile detailed.
     */
    open func getEnterprise(token: String,
                            enterprise: Enterprise,
                            completion: @escaping (EnterpriseProfile?, Error?) -> Void) {
        guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(enterprise.tenantId.uuidString)/enterprises/\(enterprise.enterpriseId.uuidString)") else { fatalError() }
        
        var request = URLRequest(url: url)
        request.addBearerAuthorizationToken(token: token)
        request.httpMethod = "GET"
        
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
                let response = try JSONDecoder().decode(EnterpriseProfile.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    /**
    Update Company informations.
    - parameters:
        - token: got from "Create User token" request.
        - enterprise: Fintech company object with unique ids of the tenant and the company itself.
        - enterpriseProfile: if optional param is nil won't update that information.
    - returns: EnterpriseProfile updated.
     */
    open func enterprise(token: String,
                         enterprise: Enterprise,
                         enterpriseProfile: EnterpriseProfile,
                         completion: @escaping (EnterpriseProfile?, Error?) -> Void ) {
        
        guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(enterprise.tenantId.uuidString)/enterprises/\(enterprise.enterpriseId.uuidString)") else { fatalError() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(enterpriseProfile)
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
                let reply = try JSONDecoder().decode(EnterpriseProfile.self, from: data)
                completion(reply, nil)
            } catch {
                completion(nil, WebserviceError.NOJSONReply)
            }
        }.resume()
    }
}
