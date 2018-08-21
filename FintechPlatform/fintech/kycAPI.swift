//
//  kycAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 31/05/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
class kycAPI {
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    
    func kycRequired(token: String, tenantId: String, ownerId: String, accountId: String, accountType: String, completion: @escaping ([DocType]?, Error?) -> Void) {
        let path = NetHelper.getPath(from: accountType)
    
        guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/\(path)/\(ownerId)/accounts/\(accountId)/kycRequiredDocuments")
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
                let reply = try JSONSerialization.jsonObject(
                    with: data,
                    options: []) as? [String:Any]
                var kycRequired = [DocType]()
                
                if let jsonArray = reply?["docType"] as? [[String]] {
                    
                    jsonArray.forEach { types in
                        kycRequired = types.map { (type: String) -> DocType in
                            guard let docType = DocType(rawValue: type) else { return DocType.PASSPORT }
                            return docType
                        }
                    }
                }
                
                completion(kycRequired, nil)
            } catch {
                completion(nil, WebserviceError.NOJSONReply)
            }
        }.resume()
    }
}
