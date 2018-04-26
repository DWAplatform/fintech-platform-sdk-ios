//
//  ProfileAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 11/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
open class ProfileAPI {
    lazy var session: SessionProtocol = URLSession.shared
    
    private let hostName: String
    
    public init(hostName: String) {
        self.hostName = hostName
    }
    /**
     Get informations about User [userid] from Fintech Platform identified from [tenantId].
     - parameters:
         - token: got from "Create User token" request.
         - tenantId: Fintech tenant id
         - userId: Fintech unique id, identify User.
         - completion: UserProfile contains all details about user profile.
     - returns: UserProfile, all details about user profile.
     */
    open func searchUser(token: String,
                    tenantId: String,
                    userId: String,
                    completion: @escaping (UserProfile?, Error?) -> Void) {
        
        guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/users/\(userId)") else { fatalError() }
        var request = URLRequest(url: url)
        request.addBearerAuthorizationToken(token: token)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { (data, response, error) in
            
            let (userprofile, error) = self.searchUserReplyParser(data: data, response: response, error: error)
            completion(userprofile, error)
            
        }.resume()
    }
    /**
    Update User informations.
    - parameters:
        - token: got from "Create User token" request.
        - tenantId: Fintech tenant id
        - userId: Fintech unique id, identify User.
        - nationality: nation code identifier using ISO 3166-1 alpha-2
        - countryofresidence: country code identifier using ISO 3166-1 alpha-2
        - birthday: Date format
        - photo: Base 64 encoded image
        - income: annual income range, identified with a number for every range:
            * "1": 0 – 18k
            * "2": 18 – 30k
            * "3": 30 – 50k
            * "4": 50 – 80k
            * "5": 80 – 120k
            * "6": > 120k
     */
    open func editProfile(token: String,
                 userId: String,
                 tenantId: String,
                 name: String? = nil,
                 surname: String? = nil,
                 nationality: String? = nil,
                 countryofresidence: String? = nil,
                 birthday: Date? = nil,
                 address: String? = nil,
                 zipcode: String? = nil,
                 city: String? = nil,
                 photo: String? = nil,
                 telnum: String? = nil,
                 email: String? = nil,
                 jobinfo: String? = nil,
                 income: String? = nil,
                 completion: @escaping (UserProfileResponse?, Error?) -> Void) {
        
        do {
            guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/users/\(userId)") else { fatalError() }

            var request = URLRequest(url: url)
            
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            
            jsonObject.setValue(userId, forKey: "userId")
            
            if let name = name {
                jsonObject.setValue(name, forKey: "name")
            }
            if let surname = surname {
                jsonObject.setValue(surname, forKey: "surname")
            }
            if let nationality = nationality {
                jsonObject.setValue(nationality, forKey: "nationality")
            }
            if let countryofresidence = countryofresidence {
                jsonObject.setValue(countryofresidence, forKey: "countryOfResidence")
            }
            if let birthday = birthday {
                // from  timeinterval to "yyyy-MM-dd"
                
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd"
                let str = dayTimePeriodFormatter.string(from: birthday)
                jsonObject.setValue(str, forKey: "birthday")
            }
            if let address = address {
                jsonObject.setValue(address, forKey: "addressOfResidence")
            }
            
            if let zipcode = zipcode {
                jsonObject.setValue(zipcode, forKey: "postalCode")
            }
            if let city = city {
                jsonObject.setValue(city, forKey: "cityOfResidence")
            }
            if let photo = photo {
                jsonObject.setValue(photo, forKey: "photo")
            }
            if let telnum = telnum {
                jsonObject.setValue(telnum, forKey: "telephone")
            }
            if let email = email {
                jsonObject.setValue(email, forKey: "email")
            }
            if let jobinfo = jobinfo {
                jsonObject.setValue(jobinfo, forKey: "occupation")
            }
            if let income = income {
                jsonObject.setValue(income, forKey: "incomeRange")
            }

            let jsdata = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
            
            request.httpBody = jsdata
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            

            request.addBearerAuthorizationToken(token: token)
            request.httpMethod = "PUT"
            
            
            
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
                    let user = try JSONSerialization.jsonObject(
                        with: data,
                        options: []) as? [String:String]
                    
                    guard let userid = user?["userId"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    let tokenuser = user?["tokenuser"]
                    
                    var up = UserProfileResponse(userid: userid)
                    up.token = tokenuser
                    
                    completion(up, nil)
                } catch {
                    completion(nil, error)
                }
                
            }.resume()
        } catch let error {
            completion(nil, error)
        }
    }
    /**
     Send User IDs document to Fintech Platform.
     - parameters:
        - token: got from "Create User token" request.
        - tenantId: Fintech tenant id
        - userId: Fintech unique id, identify User.
        - docType: type of document uploaded [IDENTITY_CARD, PASSPORT, DRIVING_LICENCE ]
        - documents: Array of Base 64 encoded image uploaded, usually front and back of the document.
        - idempotency: parameter to avoid multiple inserts.
        - completion: return document UUID identifier.
     - returns: return document UUID identifier.
     */
    public func documents(token: String,
                    userId: String,
                    tenantId: String,
                    doctype: String,
                    documents: [String?],
                    idempotency: String,
                    completion: @escaping (String?, Error?) -> Void) {
    
        guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/users/\(userId)/documents") else { fatalError() }
    
        var request = URLRequest(url: url)
    
        do {
            var pages = [String]()
            for page in documents {
                if let page = page {
                    pages.append(page)
                }
            }
            
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            jsonObject.setValue(doctype, forKey: "docType")
            jsonObject.setValue(pages, forKey: "pages")
            let jsdata = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
            
            request.httpBody = jsdata
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            request.addBearerAuthorizationToken(token: token)
            request.httpMethod = "POST"
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
                    let docs = try JSONSerialization.jsonObject(
                        with: data,
                        options: []) as? [String:String]
                    
                    guard let documentId = docs?["documentId"] else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    completion(documentId, nil)
                } catch {
                    completion(nil, error)
                }
                
            }.resume()
        } catch let error {
            completion(nil, error)
        }
    }
    
    /**
     Get User documents from Fintech Platform.
     - parameters:
        - token: got from "Create User token" request.
        - tenantId: Fintech tenant id
        - userId: Fintech unique id, identify User.
        - completion: returns list of documents uploaded to Fintech Platform
     - returns: returns list of documents uploaded to Fintech Platform
     */
    public func getDocuments(token: String,
                      userId: String,
                      tenantId: String,
                      completion: @escaping ([UserDocuments?]?, Error?) -> Void){
        
        guard let url = URL(string: hostName + "/rest/v1/fintech/tenants/\(tenantId)/users/\(userId)/documents/") else { fatalError() }
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
                let responseArray = try JSONSerialization.jsonObject(
                    with: data,
                    options: []) as? [[String:Any]]
                
                guard let response = responseArray else {
                    completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                    return
                }
                
                var listDocuments = [UserDocuments]()
                
                for singleDocument in response {
                    var listPages = [String]()
                    if let pages = singleDocument["pages"] as? [String] {
                        for page in pages {
                            listPages.append(page)
                        }
                    }
                    let docType = singleDocument["doctype"] as? String
                    guard let documentId = singleDocument["documentId"] as? String else {
                        completion(nil, WebserviceError.MissingMandatoryReplyParameters)
                        return
                    }
                    
                    listDocuments.append(UserDocuments(docId: documentId, doctype: docType, pages: listPages))
                }
                
                completion(listDocuments, nil)

            } catch {
                completion(nil, error)
            }
            
        }.resume()
        
        
    }
    
    private func searchUserReplyParser(data: Data?, response: URLResponse?, error: Error?) -> (UserProfile?, Error?) {
        
        guard error == nil else { return (nil, error) }
        guard let data = data else {
            return (nil, WebserviceError.DataEmptyError)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return (nil, WebserviceError.NoHTTPURLResponse)
        }
        
        if (httpResponse.statusCode == 403) {
            return (nil, nil)
        }
        
        if (httpResponse.statusCode == 404) {
            return (nil, WebserviceError.ResourseNotFound)
        }
        
        if (httpResponse.statusCode != 200) {
            return (nil, WebserviceError.StatusCodeNotSuccess)
        }
        
        do {
            let dictuserprofile = try JSONSerialization.jsonObject(
                with: data,
                options: []) as? [String:String]
            
            let userprofile: UserProfile?
            if let userid = dictuserprofile?["userId"] {
                userprofile = UserProfile(userid: userid)
            } else {
                userprofile = nil
            }
            
            userprofile?.name = dictuserprofile?["name"]
            userprofile?.surname = dictuserprofile?["surname"]
            userprofile?.nationality = dictuserprofile?["nationality"]
            
            if let birthday = dictuserprofile?["birthday"] {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let optDateBirthday: Date? = dateFormatter.date(from: birthday)
                if let dateBirthday = optDateBirthday {
                    userprofile?.birthday = dateBirthday
                }
            }
            
            userprofile?.countryOfResidence = dictuserprofile?["countryOfResidence"]
            userprofile?.addressOfResidence = dictuserprofile?["addressOfResidence"]
            userprofile?.postalCode = dictuserprofile?["postalCode"]
            userprofile?.cityOfResidence = dictuserprofile?["cityOfResidence"]
            userprofile?.telephone = dictuserprofile?["telephone"]
            userprofile?.email = dictuserprofile?["email"]
            userprofile?.photo = dictuserprofile?["photo"]
            userprofile?.occupation = dictuserprofile?["occupation"]
            userprofile?.income = dictuserprofile?["incomeRange"]
            
            return (userprofile, nil)
        } catch {
            return (nil, nil)
        }
    }

}
