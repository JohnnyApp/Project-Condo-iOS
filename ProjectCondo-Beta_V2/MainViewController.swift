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
        var returnMsg = ""
        returnMsg = RESTAPIEngine.sharedEngine.loginEmail(_email: UsernameText.text!, _password: PasswordText.text!)
        
        if returnMsg == "" {
            Alert.showAlertWithMessage("Success!", fromViewController: self)
            //self.performSegue(withIdentifier: "GoToMainApp", sender: nil)
            showMainViewController();
        } else if returnMsg == "Invalid credentials supplied." {
            Alert.showAlertWithMessage("Email or Password was incorrect.", fromViewController: self)
            return
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
        //self.navigationController?.pushViewController(registerViewController!, animated: true
    }
    
    fileprivate func showMainViewController() {
        let MainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        self.present(MainViewController!, animated: true, completion: nil)
        //self.navigationController?.pushViewController(MainViewController!, animated: true)
    }
}
