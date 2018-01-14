//
//  UserRecord.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 6/20/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//


import UIKit

extension Dictionary {
    func nonNull2(_ key: Key) -> String {
        let value = self[key]
        if value is NSNull {
            return ""
        } else {
            return value as! String
        }
    }
}

/**
User model
 */
class UserRecord: Equatable {
    var id: NSNumber!
    var email: String!
    var password: String!
    var firstname: String!
    var lastname: String!
    var phone: String!
    var username: String!
    
    init() {
        
    }
    
    init(json: JSON) {
        id = json["id"] as! NSNumber
        email = json.nonNull2("email")
        password = json.nonNull2("password")
        firstname = json.nonNull2("first_name")
        lastname = json.nonNull2("last_name")
        phone = json.nonNull2("phoneno")
        if json["username"] != nil {
            username = json.nonNull2("username")
        }
        
    }
}

func ==(lhs: UserRecord, rhs: UserRecord) -> Bool {
    return lhs.id.isEqual(to: rhs.id)
}


