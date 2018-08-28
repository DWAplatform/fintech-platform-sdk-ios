//
//  kycAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 31/05/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
open class KycAPI {
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    
    /**
     * Documents type required for the KYC process. Notice that the Nationality of User is mandatory.
     - parameters:
     - token: got from "Create User token" request.
     - tenantId: Fintech tenant id.
     - userId: Fintech id of the User of the Fintech Tenant.
     - completion: callback contains the list of docType required.
     */
    open func kycRequired(token: String,
                          tenantId: String,
                          ownerId: String,
                          accountId: String,
                          accountType: String,
                          completion: @escaping ([DocType]?, Error?) -> Void) {
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
    
    /**
     * Needed to begin a KYC procedure. The validate [documentId] can take from 2h to 2 days to complete.
     - parameters:
     - token: got from "Create User token" request.
     */
    open func kycProcedure(token: String,
                      account: Account,
                      documentId: UUID,
                      completion: @escaping (KycRequested?, Error?) -> Void) {
        
        struct Body: Codable {
            var documentId: String
        }
        
        struct Response: Codable {
            var kycId: UUID
            var documentId: UUID
            var status: KycStatus
            
            var kycRequested: KycRequested {
                return KycRequested(kycId: kycId, documentId: documentId, status: status)
            }
        }

        guard let url = URL(string: "/rest/v1/fintech/tenants/\(account.tenantId.uuidString)/\(account.accountType))/\(account.ownerId.uuidString)/accounts/\(account.accountId.uuidString)/kycs") else { fatalError() }
        
        let body = Body(documentId: documentId.uuidString)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
                completion(reply.kycRequested, nil)
            } catch {
                completion(nil, WebserviceError.NOJSONReply)
            }
        }.resume()
        
    }
    
    /*
    KOTLIN VERSION

     open fun kycProcedure(token: String,
     account: Account,
     documentId: UUID,
     completion: (KycRequested?, Exception?) -> Unit): IRequest<*>? {
     val url = netHelper.getURL("/rest/v1/fintech/tenants/${account.tenantId}/${netHelper.getPathFromAccountType(account.accountType)}/${account.ownerId}/accounts/${account.accountId}/kycs")
     
     val jsonObject = JSONObject()
     jsonObject.put("documentId", documentId.toString())
     
     var request: IRequest<*>?
     try {
     val r = requestProvider.jsonObjectRequest(Request.Method.POST, url, jsonObject,
     netHelper.getHeaderBuilder().authorizationToken(token).getHeaderMap(), { response ->
     
     val error = response.optJSONObject("error")
     error?.let {
     val rep =
     try {
     Error(ErrorCode.valueOf(error.getString("code")), error.getString("message"))
     } catch (x: Exception) {
     Error(ErrorCode.unknown_error, "[${error.getString("code")}] ${error.getString("message")}")
     }
     
     completion(null, NetHelper.APIResponseError(listOf(rep), null))
     return@jsonObjectRequest
     }
     
     val kyc = KycRequested(
     UUID.fromString(response.getString("kycId")),
     UUID.fromString(response.getString("documentId")),
     KycStatus.valueOf(response.getString("status")))
     completion(kyc, null)
     }) { error ->
     completion(null, netHelper.createRequestError(error))
     }
     r.setIRetryPolicy(netHelper.defaultpolicy)
     queue.add(r)
     request = r
     } catch (e: Exception) {
     log.error(TAG, "kycRequired", e)
     request = null
     }
     return request
     }

 */
}
