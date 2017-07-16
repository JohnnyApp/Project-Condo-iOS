//
//  GroupRecord.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 6/20/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

import UIKit

typealias JSON = [String: AnyObject]
typealias JSONArray = [JSON]

class GroupRecord {
    let id: NSNumber
    var name: String
    
    init(json: JSON) {
        id = json["id"] as! NSNumber
        name = json["name"] as! String
    }
}
