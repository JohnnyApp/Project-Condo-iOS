//
//  RestAPIEngine.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 6/18/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//  TEST

//import Foundation
import UIKit
import Foundation
import SwiftyJSON

//Server Setup Parameters -
//private let ApiKey = "4be93293a709f0bbad4e5f6da89130c870889c34471ad9849ee8a74c52336c2a"       //Demo
private let ApiKey = "0e72faf8133c347beec46d2204a96d3c1e025a328ebc9c0f3f2a2767bf5d5d4f"         //Localhost
//private let BaseInstanceUrl = "http://ec2-52-37-95-16.us-west-2.compute.amazonaws.com/api/v2" //Demo
private let BaseInstanceUrl = "http://localhost:8080/api/v2"                                    //Localhost
private let UserRegisterExtension = "/user/register?login=true"
private let UserLoginExtension = "/user/session"
private let HomeTableExtension = "/mongodb/_table/home"
private let UserHomeRelationExtension = "/mongodb/_table/userhomerelation"
private let kSessionTokenKey = "SessionToken"
private let DbServiceName = "db/_table"
private let ContainerName = "profile_images"
//Server Setup Parameters +

//Defaults -
let kUserEmail = "UserEmail"
let kUserName = "UserName"
let kPassword = "UserPassword"
//Defaults +

typealias SuccessClosure = (JSON?) -> Void
typealias ErrorClosure = (NSError) -> Void

//Error -
extension NSError {
    var errorMessage: String {
        //Need to Fix Later -
        /*if let errorMessage = self.userInfo["error"]?["message"] as? String {
         return errorMessage
         }*/
        //Need to Fix Later +
        return "Unknown error occurred"
    }
}
//Error +

//Routings -
enum Routing {
    case user(resourseName: String)
    case service(tableName: String)
    case resourceFolder(folderPath: String)
    case resourceFile(folderPath: String, fileName: String)
    
    var path: String {
        switch self {
        //rest path for request, form is <base instance url>/api/v2/user/resourceName
        case let .user(resourceName):
            return "\(BaseInstanceUrl)/user/\(resourceName)"
            
        //rest path for request, form is <base instance url>/api/v2/<serviceName>/<tableName>
        case let .service(tableName):
            return "\(BaseInstanceUrl)/\(DbServiceName)/\(tableName)"
            
        // rest path for request, form is <base instance url>/api/v2/files/container/<folder path>/
        case let .resourceFolder(folderPath):
            return "\(BaseInstanceUrl)/files/\(ContainerName)/\(folderPath)/"
            
        //rest path for request, form is <base instance url>/api/v2/files/container/<folder path>/filename
        case let .resourceFile(folderPath, fileName):
            return "\(BaseInstanceUrl)/files/\(ContainerName)/\(folderPath)/\(fileName)"
        }
    }
}
//Routings +

final class RESTAPIEngine {
    
    static let sharedEngine = RESTAPIEngine()
    
    //API Parameters -
    let headerParams: [String: String] = {
        let dict = ["X-DreamFactory-Api-Key": ApiKey]
        return dict
    }()
    
    var sessionHeaderParams: [String: String] {
        var dict = headerParams
        dict["X-DreamFactory-Session-Token"] = sessionToken
        return dict
    }
    //API Parameters +
    
    fileprivate let api = NIKApiInvoker.sharedInstance
    
    //Session Token -
    var _sessionToken: String?
    var sessionToken: String? {
        get {
            if _sessionToken == nil {
                _sessionToken = UserDefaults.standard.value(forKey: kSessionTokenKey) as? String
            }
            return _sessionToken
        }
        set {
            if let value = newValue {
                UserDefaults.standard.setValue(value, forKey: kSessionTokenKey)
                UserDefaults.standard.synchronize()
                _sessionToken = value
            } else {
                UserDefaults.standard.removeObject(forKey: kSessionTokenKey)
                UserDefaults.standard.synchronize()
                _sessionToken = nil
            }
        }
    }
    //Session Token +
    
    //Logout Function -
    func logout() -> Void{
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    //Logout Function +
    
    //Login Function 2 -
    func loginWithEmail2(_ email: String, password: String, success: @escaping SuccessClosure, failure: @escaping ErrorClosure) {
        
        let requestBody: [String: AnyObject] = ["email": email as AnyObject,
                                                "password": password as AnyObject]
        
        callApi(Routing.user(resourseName: "session").path, method: "POST", queryParams: nil, body: requestBody as AnyObject?, headerParams: headerParams, success: success, failure: failure)
    }
    //Login Function 2 +
    
    //Register Function 2 -
    func registerWithEmail2(_ email: String, password: String, firstname: String, lastname: String, username: String, phoneno: String, success: @escaping SuccessClosure, failure: @escaping ErrorClosure) {
        
        //login after signup
        let queryParams: [String: AnyObject] = ["login": "1" as AnyObject]
        let requestBody: [String: AnyObject] = ["email": email as AnyObject,
                                                "password": password as AnyObject,
                                                "first_name": firstname as AnyObject,
                                                "last_name": lastname as AnyObject,
                                                "phone": phoneno as AnyObject,
                                                "username": username as AnyObject]
        
        callApi(Routing.user(resourseName: "register").path, method: "POST", queryParams: queryParams, body: requestBody as AnyObject?, headerParams: headerParams, success: success, failure: failure)
    }
    //Register Function 2 +
    
    //Call API -
    fileprivate func callApi(_ restApiPath: String, method: String, queryParams: [String: AnyObject]?, body: AnyObject?, headerParams: [String: String]?, success: SuccessClosure?, failure: ErrorClosure?) {
        api.restPath(path: restApiPath, method: method, queryParams: queryParams, body: body, headerParams: headerParams, contentType: "application/json", completionBlock: { (response, error) -> Void in
            if let error = error, failure != nil {
                failure!(error)
            } else if let success = success {
                success(response)
            }
        })
    }
    //Call API +
}

