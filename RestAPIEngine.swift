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
//import SwiftyJSON

let kRESTServerActiveCountUpdated = "kRESTServerActiveCountUpdated"

//Server Setup Parameters -
//private let ApiKey = "4be93293a709f0bbad4e5f6da89130c870889c34471ad9849ee8a74c52336c2a"       //Demo
private let ApiKey = "0e72faf8133c347beec46d2204a96d3c1e025a328ebc9c0f3f2a2767bf5d5d4f"         //Localhost
//private let BaseInstanceUrl = "http://ec2-52-37-95-16.us-west-2.compute.amazonaws.com/api/v2" //Demo
private let BaseInstanceUrl = "http://localhost:8080/api/v2"                                    //Localhost
private let kSessionTokenKey = "SessionToken"
//private let DbServiceName = "db/_table"
private let DbServiceName = "mongodb/_table"
private let ContainerName = "profile_images"
//Server Setup Parameters +

//Defaults -
let kUserEmail = "UserEmail"
let kUserName = "UserName"
let kPassword = "UserPassword"
let kCurrHouseName = "CurrentHouse"
//Defaults +

typealias SuccessClosure = (JSON?) -> Void
typealias ErrorClosure = (NSError) -> Void

typealias SuccessHandler = (Bool, String?)->Void
typealias RestResultClosure = (RestCallResult) -> Void
enum RestCallResult {
    case success(result: JSON?)
    case failure(error: NSError)
    case unAuthorizedReauthenticate
    
    var bIsSuccess: Bool {
        switch (self) {
        case ( .success(_)): return true
        default: return false
        }
    }
    var json: JSON? {
        switch (self) {
        case (let .success(result)): return result
        default: return nil
        }
    }
    var error: NSError? {
        switch (self) {
        case (let .failure(error)): return error
        default: return nil
        }
    }
}

enum HTTPMethod: String { case GET, POST, PATCH, DELETE }

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
    fileprivate let kRestSignIn = "/user/session"
    fileprivate var restActiveCallCount = 0
    fileprivate(set) var sessionEmail: String? = nil
    fileprivate var sessionPwd: String? = nil
    
    
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
    
    //Login Function -
    func loginWithEmail(_ email: String, password: String, success: @escaping SuccessClosure, failure: @escaping ErrorClosure) {
        
        let requestBody: [String: AnyObject] = ["email": email as AnyObject,
                                                "password": password as AnyObject]
        
        callApi(Routing.user(resourseName: "session").path, method: "POST", queryParams: nil, body: requestBody as AnyObject?, headerParams: headerParams, success: success, failure: failure)
    }
    //Login Function +
    
    //Register Function -
    func registerWithEmail(_ email: String, password: String, firstname: String, lastname: String, username: String, phoneno: String, success: @escaping SuccessClosure, failure: @escaping ErrorClosure) {
        
        //login after signup
        let queryParams: [String: AnyObject] = ["login": "1" as AnyObject]
        let requestBody: [String: AnyObject] = ["email": email as AnyObject,
                                                "password": password as AnyObject,
                                                "first_name": firstname as AnyObject,
                                                "last_name": lastname as AnyObject,
                                                "phone": phoneno as AnyObject,
                                                "username": username as AnyObject]
        
        callApi(Routing.user(resourseName: "register").path, method: "POST", queryParams: queryParams, body: requestBody as AnyObject?, headerParams: headerParams, success: success, failure: failure)
        sleep(2)
        let userRequestBody: [String: AnyObject] = ["resource": requestBody as AnyObject]
        callApi(Routing.service(tableName: "user").path, method: "POST", queryParams: nil, body: userRequestBody as AnyObject?, headerParams: sessionHeaderParams, success: success, failure: failure)
    }
    //Register Function +
    
    //Add House Function -
    func createNewHouse(_ houseDetails: JSON, success: @escaping SuccessClosure, failure: @escaping ErrorClosure) {
        
        let requestBody: [String: AnyObject] = ["resource": houseDetails as AnyObject]
        
       callApi(Routing.service(tableName: "home").path, method: "POST", queryParams: nil, body: requestBody as AnyObject?, headerParams: sessionHeaderParams, success: success, failure: failure)
    }
    //Add House Function +
    
    //Add User/House Relationship -
    func createUserHomeRelation(_ email: String, houseId: String, success: @escaping SuccessClosure, failure: @escaping ErrorClosure) {
        let simpleBody: [String: AnyObject] = ["email": email as AnyObject,
                                                "house_id": houseId as AnyObject]
        let requestBody: [String: AnyObject] = ["resource": simpleBody as AnyObject]
        
        callApi(Routing.service(tableName: "home_user_relationship").path, method: "POST", queryParams: nil, body: requestBody as AnyObject?, headerParams: sessionHeaderParams, success: success, failure: failure)
    }
    //Add User/House Relationship +
    
    //Get House Per User -
    func getHousesFromServerWithUserEmail(_ userEmail: String, success: @escaping SuccessClosure, failure: @escaping ErrorClosure) {
        let queryParams: [String: AnyObject] = ["filter": "email=\(userEmail)" as AnyObject]
        callApi(Routing.service(tableName: "home_user_relationship").path, method: "GET", queryParams: queryParams, body: nil, headerParams: sessionHeaderParams, success: success, failure: failure)
    }
    //Get House Per User +
    
    //Get House Array from API Call -
    func getHouseIDArray(_ userEmail: String, completionHandler: @escaping ([String]?, Error?) -> Void) {
        getHousesFromServerWithUserEmail(userEmail, success: { response in
            let records = response!["resource"] as! JSONArray
            var strings = [String]()
            for recordInfo in records {
                if recordInfo["house_id"] != nil {
                    strings.append(recordInfo["house_id"] as! String)
                }
            }
            completionHandler(strings, nil)
        }, failure: { error in
            NSLog("Server Error: \(error)")
            completionHandler(nil,error)
        })
    }
    //Get House Per from API Call +
    
    //Get House Name  -
    func getHouseNameFromHouseID(_ houseid: String, success: @escaping SuccessClosure, failure: @escaping ErrorClosure) {
        // only get contact_group_relationships for this group
        let queryParams: [String: AnyObject] = ["filter": "_id=\(houseid)" as AnyObject]
        callApi(Routing.service(tableName: "home").path, method: "GET", queryParams: queryParams, body: nil, headerParams: sessionHeaderParams, success: success, failure: failure)
    }
    //Get House Per User +
    
    //Get House Array from API Call -
    func getHouseNameArray(_ houseid: String, completionHandler: @escaping (String?, Error?) -> Void) {
        getHouseNameFromHouseID(houseid, success: { response in
            let records = response!["resource"] as! JSONArray
            var housenamestring = ""
            for recordInfo in records {
                if recordInfo["housename"] != nil {
                    housenamestring = recordInfo["housename"] as! String
                }
            }
            completionHandler(housenamestring, nil)
        }, failure: { error in
            NSLog("Server Error: \(error)")
            completionHandler(nil,error)
        })
    }
    //Get House Per from API Call +
    
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
    
    fileprivate func restErrorForStatusCode(_ statusCode: Int, json: JSON?) -> NSError {
        var userInfo = json
        if let pr = json {
            if let errorDict = pr["error"] {
                if let errorDict = errorDict as? JSON {
                    if let msg = errorDict["message"] as? String {
                        userInfo = [NSLocalizedDescriptionKey : msg as AnyObject]
                    }
                }
            }
        }
        let error = NSError(domain: "DreamFactoryAPI", code: statusCode, userInfo: userInfo)
        return error
    }
    
    fileprivate func setUserDataFromJson(_ signInJson:JSON?) -> Bool {
        if let signInJson = signInJson {
            // elements: session_token, email, last_name, role_id, session_id, role, last_login_date, is_sys_admin, host, name, id
            sessionToken = signInJson["session_token"] as? String
            sessionEmail = signInJson["email"] as? String
        }
        else {
            sessionToken = nil
            sessionEmail = nil
            sessionPwd = nil
        }
        // Could set other data here
        return (sessionToken != nil)
    }
    
    func signInWithEmail(_ email:String, password:String, signInHandler: @escaping SuccessHandler) {
        let requestData = ["email" : email, "password" : password] as AnyObject
        
        callRestService(kRestSignIn, method: .POST, queryParams: nil, body: requestData) { (callResult) in
            var bSuccess = false
            if callResult.bIsSuccess {
                self.sessionPwd = password
                bSuccess = self.setUserDataFromJson(callResult.json)
            }
            signInHandler(bSuccess, callResult.error?.localizedDescription)
        }
    }
    
    fileprivate func callCountIncrement(_ bIsEntry:Bool) {
        synchronizedSelf() {
            restActiveCallCount = max(0, restActiveCallCount + (bIsEntry ? 1 : -1))
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(rawValue: kRESTServerActiveCountUpdated), object: self, userInfo: ["count" : NSNumber.init(value: self.restActiveCallCount as Int)])
            }
        }
    }
    
    fileprivate func checkData(_ data: Data?, response: URLResponse?, error: NSError?) -> RestCallResult {
        var parsedJSONResults: JSON?
        
        if let data = data {
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                parsedJSONResults = jsonData as? JSON
            }
            catch {
                // Ignore if not JSON
            }
        }
        
        if let response_error = error {
            let error = NSError(domain: response_error.domain, code: response_error.code, userInfo: parsedJSONResults)
            return .failure(error: error)
        }
        else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 401 && sessionToken != nil && sessionEmail != nil && sessionPwd != nil {
                sessionToken = nil
                return .unAuthorizedReauthenticate
            }
            else if NSLocationInRange(statusCode, NSMakeRange(200, 99)) {
                return .success(result: parsedJSONResults)
            }
            else {
                let error = self.restErrorForStatusCode(statusCode, json: parsedJSONResults)
                return .failure(error: error)
            }
        }
    }
    
    fileprivate func buildRequest(_ path: String, method: HTTPMethod, queryParams: [String: String]?, body: AnyObject?) -> URLRequest {
        let request = NSMutableURLRequest()
        var requestUrl = path
        
        // build the query params into the URL. ["filter" : "true", "sort" : "1"] becomes "<url>?filter=true&sort=1
        if let queryParams = queryParams {
            let parameterString = queryParams.stringFromHttpParameters()
            requestUrl = "\(path)?\(parameterString)"
        }
        
        let URL = Foundation.URL(string: requestUrl)!
        request.url = URL
        request.timeoutInterval = 30
        
        request.httpMethod = method.rawValue
        if let body = body,
            let data = try? JSONSerialization.data(withJSONObject: body, options: []) {
            
            //else if let body = body as? NIKFile {
            //    data = body.data
            //}
            //else {
            //    data = body.data(using: String.Encoding.utf8)
            //}
            
            let postLength = "\(data.count)"
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.httpBody = data
        }
        
        return request as URLRequest
    }
    
    //Call Rest Service -
    func callRestService(_ relativePath: String, method:HTTPMethod, queryParams: [String: String]?, body: AnyObject?, resultClosure:@escaping RestResultClosure) {
        
        let path = BaseInstanceUrl + relativePath
        
        callCountIncrement(true)
        let request = buildRequest(path, method: method, queryParams: queryParams, body: body)
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = sessionHeaderParams
        let session = URLSession(configuration: config)
        print("REST(\(method.rawValue))->\(request.url?.absoluteString)")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            self.callCountIncrement(false)
            let callResult = self.checkData(data, response: response, error: error as NSError?)
            switch callResult {
            case .unAuthorizedReauthenticate:
                print("REST:UnAuthorizedReauthenticate")
                self.signInWithEmail(self.sessionEmail!, password: self.sessionPwd!) { (bSuccess, _) in
                    if bSuccess && self.restActiveCallCount < 20 { // ReAuth worked, try original request again. Prevent endless looping.
                        self.callRestService(relativePath, method: method, queryParams: queryParams, body: body, resultClosure: resultClosure)
                    }
                    else {
                        resultClosure(callResult)
                    }
                }
            default:
                resultClosure(callResult)
            }
        })
        task.resume()
    }
    //Call Rest Service +
    fileprivate func synchronizedSelf(_ closure: () -> ()) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        closure()
    }
    
}

