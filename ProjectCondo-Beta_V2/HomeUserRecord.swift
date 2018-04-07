//
//  HomeUserRecord.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 4/6/18.
//  Copyright © 2018 jonathan laroco. All rights reserved.
//

import Foundation

import UIKit

extension Dictionary {
    func nonNull(_ key: Key) -> String {
        let value = self[key]
        if value is NSNull {
            return ""
        } else {
            return value as! String
        }
    }
}

/**
 Home model
 */
class HomeUserRecord: Equatable {
    var id: String!
    var home_id: String!
    var home_name: String!
    var email: String!
    
    init() {
        
    }
    
    init(json: JSON) {
        id = json["_id"] as! String
        home_id = json.nonNull("home_id")
        home_name = json.nonNull("home_name")
        email = json.nonNull("email")
    }
}

func ==(lhs: HomeUserRecord, rhs: HomeUserRecord) -> Bool {
    return lhs.id.isEqual(rhs.id)
}
