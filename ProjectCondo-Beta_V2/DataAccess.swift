//
//  DataAccess.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 3/29/18.
//  Copyright © 2018 jonathan laroco. All rights reserved.
//

import Foundation

private let kApiKey = "0e72faf8133c347beec46d2204a96d3c1e025a328ebc9c0f3f2a2767bf5d5d4f"
let kBaseInstanceUrl = "http://localhost:8080/api/v2"
private let kSessionTokenKey = "SessionToken"
//private let DbServiceName = "db/_table"
private let DbServiceName = "/mongodb/_table"
private let ContainerName = "profile_images"

private let kRestHome = "mongodb/_table/home"
private let kRestHomeUserRelationship = "/mongodb/_table/home_user_relationship"

protocol HomesDelegate {
    func setHomess(_ homes:[HomeRecord])
    func dataAccessError(_ error:NSError?)
}

class DataAccess {
    static let sharedInstance = DataAccess()
    //fileprivate var restClient = RESTAPIEngine(apiKey: kApiKey, instanceUrl: kBaseInstanceUrl)
    
    func getHomes(_ group:HomeRecord?, email: String, resultDelegate: HomesDelegate) {
        getHomesAll(email, resultDelegate: resultDelegate)
    }
    
    fileprivate func getHomesAll(_ userEmail: String, resultDelegate: HomesDelegate) {
        let queryParams: [String: AnyObject] = ["filter": "email=\(userEmail)" as AnyObject]
        /*restClient.callRestService(kRestContact, method: .GET, queryParams: queryParams, body: nil) { restResult in
            if restResult.bIsSuccess {
                var contacts = [ContactRecord]()
                if let contactsArray = restResult.json?["resource"] as? JSONArray {
                    for contactJSON in contactsArray {
                        if let contact = ContactRecord(json:contactJSON) {
                            contacts.append(contact)
                        }
                    }
                }
                DispatchQueue.main.async {
                    resultDelegate.setContacts(contacts)
                }
            }
            else {
                DispatchQueue.main.async {
                    resultDelegate.dataAccessError(restResult.error)
                }
            }
        }*/
    }
}
