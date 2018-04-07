//
//  CreateHouseViewController.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 8/11/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

import UIKit

class CreateHouseViewController: UIViewController {
    @IBOutlet weak var HouseNameTxt: UITextField!
    @IBOutlet weak var Address1Txt: UITextField!
    @IBOutlet weak var Address2Txt: UITextField!
    @IBOutlet weak var CityTxt: UITextField!
    @IBOutlet weak var StateTxt: UITextField!
    @IBOutlet weak var PostCodeTxt: UITextField!
    
    var homeRecord: HomeRecord?

    @IBAction func CreateAHouseInMongoDB(_ sender: Any) {
        
        //Make sure everything is filled out -
        if ((HouseNameTxt.text?.isEmpty) != false) {
            Alert.showAlertWithMessage("Please enter a House Name", fromViewController: self)
            return
        } else if ((Address1Txt.text?.isEmpty) != false) {
            Alert.showAlertWithMessage("Please enter a Address 1", fromViewController: self)
            return
        } else if ((CityTxt.text?.isEmpty) != false) {
            Alert.showAlertWithMessage("Please enter a city", fromViewController: self)
            return
        } else if ((StateTxt.text?.isEmpty) != false) {
            Alert.showAlertWithMessage("Please enter a state", fromViewController: self)
            return
        } else if ((PostCodeTxt.text?.isEmpty) != false) {
            Alert.showAlertWithMessage("Please enter a post code", fromViewController: self)
            return
        }
        //Make sure everything is filled out +
        var Add2Field = ""
        var idtemp = ""
        //Handle Address 2 -
        if ((Address2Txt.text?.isEmpty) != false) {
            Add2Field = ""
        } else {
            Add2Field = Address2Txt.text!
        }
        //Handle Address 2 +
        
        let HomeRequestBody: [String: AnyObject] = ["housename": HouseNameTxt.text! as AnyObject,
                                                    "address1": Address1Txt.text! as AnyObject,
                                                    "address2": Address2Txt.text!as AnyObject,
                                                    "city": CityTxt.text! as AnyObject,
                                                    "state": StateTxt.text! as AnyObject,
                                                    "postcode": PostCodeTxt.text! as AnyObject]
        
        homeRecord = HomeRecord()
        RESTAPIEngine.sharedEngine.createNewHouse(HomeRequestBody, success: { response in
            let nametemp = self.HouseNameTxt.text!
            let records = response!["resource"] as! JSONArray
            for recordInfo in records {
                if (recordInfo["_id"] != nil) {
                    idtemp = recordInfo["_id"] as! String
                }
            }
            if idtemp != "" {
                self.createUserHomeRelationship(tmpHouseid: idtemp, hn: nametemp)
            }
            
        }, failure: { error in
            NSLog("Error adding new home to server: \(error)")
            DispatchQueue.main.async {
                Alert.showAlertWithMessage(error.errorMessage, fromViewController: self)
                self.navBar.enableAllTouch()
            }
        })
        self.showHouseListViewController()
    }
    
    fileprivate func createUserHomeRelationship(tmpHouseid :String, hn :String) {
        
        let defaults = UserDefaults.standard
        let curremail = defaults.string(forKey: kUserEmail)! as String
        
        RESTAPIEngine.sharedEngine.createUserHomeRelation(curremail, houseId: tmpHouseid, housename: hn, success: { response in
            //Alert.showAlertWithMessage("Successful House Creation!", fromViewController: self)
        }, failure: { error in
            NSLog("Error creating user and home relationship: \(error)")
            DispatchQueue.main.async {
                Alert.showAlertWithMessage(error.errorMessage, fromViewController: self)
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    //Go to House List -
    fileprivate func showHouseListViewController() {
        let MainViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectHouseViewController")
        self.present(MainViewController!, animated: true, completion: nil)
    }
    //Go to House List +
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
