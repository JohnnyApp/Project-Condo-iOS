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

    @IBAction func CreateAHouseInMongoDB(_ sender: Any) {
        
        var Add2Field = ""
        var returnMsg = ""
        
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
        
        //Handle Address 2 -
        if ((Address1Txt.text?.isEmpty) != false) {
            Add2Field = ""
        } else {
            Add2Field = Address2Txt.text!
        }
        //Handle Address 2 +
        
        returnMsg = RESTAPIEngine.sharedEngine.createNewHouse(_housename: HouseNameTxt.text!, _address1: Address1Txt.text!, _address2: Add2Field, _city: CityTxt.text!, _state: StateTxt.text!, _postCode: PostCodeTxt.text!)
        if returnMsg == "" {
            Alert.showAlertWithMessage("Success!!!", fromViewController: self)
        } else if returnMsg != "" {
            Alert.showAlertWithMessage("ERROR!!!", fromViewController: self)
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
