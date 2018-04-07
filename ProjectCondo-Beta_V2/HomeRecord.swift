




//
//  HomeRecord.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 6/20/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//


import UIKit

extension Dictionary {
    func nonNull3(_ key: Key) -> String {
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
class HomeRecord: Equatable {
    var id: String!
    var houseName: String!
    var address1: String!
    var address2: String!
    var city: String!
    var state: String!
    var postcode: String!
    
    init() {
        
    }
    
    init(json: JSON) {
        id = json["_id"] as! String
        houseName = json.nonNull("housename")
        address1 = json.nonNull("address1")
        if json["address2"] != nil {
            address2 = json.nonNull("address2")
        }
        city = json.nonNull("state")
        postcode = json.nonNull("postcode")
    }
}

func ==(lhs: HomeRecord, rhs: HomeRecord) -> Bool {
    return lhs.id.isEqual(rhs.id)
}

