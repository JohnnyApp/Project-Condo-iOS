//
//  MainViewController.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 6/18/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var UsernameText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    
    @IBAction func SignInAction(_ sender: Any) {       
        if (UsernameText.text?.characters.count)! > 0 && (PasswordText.text?.characters.count)! > 0 {
            
            RESTAPIEngine.sharedEngine.loginWithEmail2(UsernameText.text!, password: PasswordText.text!,
                                                   success: { response in
                                                    RESTAPIEngine.sharedEngine.sessionToken = response!["session_token"] as? String
                                                    let defaults = UserDefaults.standard
                                                    defaults.setValue(self.UsernameText.text!, forKey: kUserEmail)
                                                    defaults.setValue(self.PasswordText.text!, forKey: kPassword)
                                                    defaults.synchronize()
                                                    DispatchQueue.main.async {
                                                        self.showMainViewController()
                                                    }
            }, failure: { error in
                NSLog("Error logging in user: \(error)")
                DispatchQueue.main.async {
                    Alert.showAlertWithMessage(error.errorMessage, fromViewController: self)
                }
            })
        } else {
            Alert.showAlertWithMessage("Enter email and password", fromViewController: self)
        }
        
    }
    
    @IBAction func RegisterAction(_ sender: Any) {
        showRegisterViewController();
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func showRegisterViewController() {
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserRegistrationView")
        self.present(registerViewController!, animated: true, completion: nil)
    }
    
    fileprivate func showMainViewController() {
        let MainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        self.present(MainViewController!, animated: true, completion: nil)
    }
    
    fileprivate func showHouseTableViewController() {
        let houseTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectHouseViewController")
        self.present(houseTableViewController!, animated: true, completion: nil)
    }
}
