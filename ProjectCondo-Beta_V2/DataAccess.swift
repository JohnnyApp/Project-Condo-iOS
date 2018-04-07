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
private let DbServiceName = "/mongodb/_table"
private let ContainerName = "profile_images"

private let kRestHome = "/mongodb/_table/home"
private let kRestHomeUserRelationship = "/mongodb/_table/home_user_relationship"

protocol HomesDelegate {
    func setHomes(_ homes:[HomeUserRecord])
    func dataAccessError(_ error:NSError?)
}

class DataAccess {
    static let sharedInstance = DataAccess()
    fileprivate var restClient = RESTAPIEngine()
    
    func getHomes(_ group:HomeUserRecord?, email: String, resultDelegate: HomesDelegate) {
        getHomesAll(email, resultDelegate: resultDelegate)
    }
    
    func isSignedIn() -> Bool {
        return restClient.isSignedIn
    }
    
    fileprivate func getHomesAll(_ userEmail: String, resultDelegate: HomesDelegate) {
        let queryParams = ["filter": "email=\(userEmail)"]
        restClient.callRestService(kRestHomeUserRelationship, method: .GET, queryParams: queryParams, body: nil) { restResult in
            if restResult.bIsSuccess {
                var homes = [HomeUserRecord]()
                if let homesArray = restResult.json?["resource"] as? JSONArray {
                    for homeJSON in homesArray {
                        let home = HomeUserRecord(json:homeJSON)
                        if home.id != nil {
                            homes.append(home)
                        }
                    }
                }
                DispatchQueue.main.async {
                    resultDelegate.setHomes(homes)
                }
            }
            else {
                DispatchQueue.main.async {
                    resultDelegate.dataAccessError(restResult.error)
                }
            }
        }
    }
}
