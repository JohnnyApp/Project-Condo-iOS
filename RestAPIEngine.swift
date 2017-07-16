//
//  RestAPIEngine.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 6/18/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

//import Foundation
import UIKit
import Foundation

//Server Setup Parameters -
//private let ApiKey = "0e72faf8133c347beec46d2204a96d3c1e025a328ebc9c0f3f2a2767bf5d5d4f"
private let ApiKey = "4be93293a709f0bbad4e5f6da89130c870889c34471ad9849ee8a74c52336c2a"
//private let BaseInstanceUrl = "http://localhost:8080/api/v2"
private let BaseInstanceUrl = "http://ec2-52-37-95-16.us-west-2.compute.amazonaws.com/api/v2"
//private let UserRegisterExtension = "/user/register?login=true"
private let UserRegisterExtension = "/user/register?login=true"
private let UserLoginExtension = "/user/session"
private let kSessionTokenKey = "SessionToken"
//Server Setup Parameters +

typealias SuccessClosure = (JSON?) -> Void
typealias ErrorClosure = (NSError) -> Void

final class RESTAPIEngine {
    
    static let sharedEngine = RESTAPIEngine()
    
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
    
    func loginEmail (_email: String, _password: String) -> String {
        
        let stringTxt = "{\"email\": \"" + _email + "\",\"password\": \"" + _password + "\"}"
        var outputMsg = ""
        
        let userDictionary = JSONParseDictionary(string: stringTxt)
        
        HTTPPostJSON(url: BaseInstanceUrl + UserLoginExtension , jsonObj: userDictionary as AnyObject) {
            (data: String, error: String?) -> Void in

            if error != nil {
                outputMsg = "servererror"
            } else {
                let outputDict = self.JSONParseDictionary(string: data)
                
                //Check Errors -
                if let error = outputDict["error"] as? [String : AnyObject] {
                    if (error["message"] != nil) {
                        outputMsg = error["message"] as! String
                    }
                }
                //Check Errors +
                
                //Successful -
                if outputMsg == "" {
                    if (outputDict["session_token"] != nil) {
                        self.sessionToken = outputDict["session_token"] as? String
                        let defaults = UserDefaults.standard
                        defaults.setValue(_email, forKey: "email")
                        
                        if (outputDict["first_name"] != nil) {
                            defaults.setValue(outputDict["first_name"] as? String, forKey:"firstname")
                        }
                        if (outputDict["last_name"] != nil) {
                            defaults.setValue(outputDict["last_name"] as? String, forKey:"lastname")
                        }
                        //Set Username
                        defaults.synchronize()
                    }
                }
                //Successful +
                
                
            }
        }
        sleep(2)
        return outputMsg
    }
    //Login Function +
    
    //Register Function -
    func registerWithEmail (_firstname: String, _lastname: String, _username: String, _password: String, _email: String, _phoneNo: String) -> String {
        
        let stringTxt = "{\"first_name\": \"" + _firstname + "\",\"last_name\": \"" + _lastname + "\",\"username\": \"" + _username + "\",\"email\": \"" + _email + "\",\"phone\": \"" + _phoneNo + "\",\"password\": \"" + _password + "\"}"
        var outputMsg = ""
        
        let userDictionary = JSONParseDictionary(string: stringTxt)
        
        HTTPPostJSON(url: BaseInstanceUrl + UserRegisterExtension , jsonObj: userDictionary as AnyObject) {
            (data: String, error: String?) -> Void in
            if error != nil {
                outputMsg = "servererror"
            } else {
                
                let outputDict = self.JSONParseDictionary(string: data)
                
                //Check Errors -
                if let error = outputDict["error"] as? [String : AnyObject] {
                    if let context = error["context"] as? [String : AnyObject] {
                        
                        var errArray = [String]()
                        
                        if (context["email"] != nil) {
                            errArray += context["email"] as! [String]
                        } else if (context["username"] != nil) {
                            errArray += context["username"] as! [String]
                        }
                        outputMsg = errArray[0]
                    }
                }
                //Check Errors +
                
                print("Output message" + outputMsg)
                print(data)
                
                //Successful create a new session -
                if outputMsg == "" {
                    //var sessArray = [String]()
                    
                    if (outputDict["session_token"] != nil) {
                        //Add Session Token/User Defaults -
                        print(outputDict["session_token"] as? String ?? "NOTHING")
                        self.sessionToken = outputDict["session_token"] as? String
                        let defaults = UserDefaults.standard
                        defaults.setValue(_username, forKey: "username")
                        defaults.setValue(_email, forKey: "email")
                        defaults.setValue(_firstname, forKey:"firstname")
                        defaults.setValue(_lastname, forKey:"lastname")
                        defaults.synchronize()
                        //Add Session Token/User Defaults +
                    }
                }
                //Successful create a new session +
            }
        }
        sleep(2)
        
        return outputMsg
    }

    func JSONParseDictionary(string: String) -> [String: AnyObject]{
        if let data = string.data(using: String.Encoding.utf8){
            do{
                if let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]{
                    return dictionary
                }
            }catch {
                print("error")      //LOG ERROR
            }
        }
        return [String: AnyObject]()
    }
    
    func HTTPsendRequest(request: NSMutableURLRequest,callback: @escaping (String, String?) -> Void) {
        let task = URLSession.shared.dataTask(with: request as URLRequest,completionHandler :
            {
                data, response, error in
                if error != nil {
                    callback("", (error!.localizedDescription) as String)
                } else {
                    callback(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String,nil)
                }
        })
        task.resume() //Tasks are called with .resume()
    }
    
    func HTTPPostJSON(url: String,
                      jsonObj: AnyObject,
                      callback: @escaping (String, String?) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ApiKey, forHTTPHeaderField: "X-DreamFactory-Api-Key")
        let jsonString = JSONStringify(value: jsonObj)
        let data: NSData = jsonString.data(
            using: String.Encoding.utf8)! as NSData
        request.httpBody = data as Data
        HTTPsendRequest(request: request,callback: callback)
    }
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
        }
        return ""
    }
}

