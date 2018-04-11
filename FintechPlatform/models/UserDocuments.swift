//
//  UserDocuments.swift
//  FintechPlatform
//
//  Created by ingrid on 11/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
struct UserDocuments {
    let docId: String?
    let doctype: String?
    let pages: [String]?
    
    init(docId:String?,
         doctype: String?,
         pages: [String]?) {
        
        self.docId = docId
        self.doctype = doctype
        self.pages = pages
    }
}
