//
//  RegisterViewController.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 6/18/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var phoneNoTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    
    @IBAction func userReg(_ sender: Any) {
        //Make sure everything is filled out -
        if ((firstNameTxt.text?.isEmpty) != false) {
            Alert.showAlertWithMessage("Please fill out your first name", fromViewController: self)
            return
        } else if ((lastNameTxt.text?.isEmpty) != false) {
            Alert.showAlertWithMessage("Please fill out your last name", fromViewController: self)
            return
        } else if ((emailTxt.text?.isEmpty) != false) {
            Alert.showAlertWithMessage("Please fill out your email", fromViewController: self)
            return
        } else if ((phoneNoTxt.text?.isEmpty) != false) {
            Alert.showAlertWithMessage("Please add your phone number", fromViewController: self)
            return
        } else if ((passwordTxt.text?.isEmpty) != false){
            Alert.showAlertWithMessage("Please set your password", fromViewController: self)
            return
        } else if ((confirmPasswordTxt.text?.isEmpty) != false) {
            Alert.showAlertWithMessage("Please confirm your password", fromViewController: self)
            return
        } else if passwordTxt.text != confirmPasswordTxt.text {
            Alert.showAlertWithMessage("Your passwords do not match.", fromViewController: self)
            confirmPasswordTxt.text = ""
            return
        } else if (usernameTxt.text?.characters.count)! < 6 {
            Alert.showAlertWithMessage("Username needs to be greater than 6 characters", fromViewController: self)
            return
        } else if (passwordTxt.text?.characters.count)! < 8 {
            Alert.showAlertWithMessage("Password needs to be greater than 8 characters", fromViewController: self)
            passwordTxt.text = ""
            confirmPasswordTxt.text = ""
            return
        }
        
        //Check Email has @ sign
        
        //Make sure everything is filled out +
        
        RESTAPIEngine.sharedEngine.registerWithEmail2(emailTxt.text!, password: passwordTxt.text!, firstname: firstNameTxt.text!, lastname: lastNameTxt.text!, username: usernameTxt.text!, phoneno: phoneNoTxt.text!, success: { response in
            RESTAPIEngine.sharedEngine.sessionToken = response!["session_token"] as? String
            let defaults = UserDefaults.standard
            defaults.setValue(self.emailTxt.text!, forKey: kUserEmail)
            defaults.setValue(self.usernameTxt.text!, forKey: kUserName)
            defaults.setValue(self.passwordTxt.text!, forKey: kPassword)
            defaults.synchronize()
            
            DispatchQueue.main.async {
                self.showMainViewController()
            }
        }, failure: { error in
            NSLog("Error registering new user: \(error)")
            DispatchQueue.main.async {
                Alert.showAlertWithMessage(error.errorMessage, fromViewController: self)
            }
        })
    }
    
    fileprivate func showMainViewController() {
        let MainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        self.present(MainViewController!, animated: true, completion: nil)
    }
    
    fileprivate func showHouseTableViewController() {
        let MainViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectHouseViewController")
        self.present(MainViewController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
