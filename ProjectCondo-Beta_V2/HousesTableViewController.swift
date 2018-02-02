//
//  HousesTableViewController.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 8/11/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

import UIKit

class HousesTableViewController: UITableViewController {
    
    @IBAction func OpenCreateHouse(_ sender: Any) {
        showCreateHouseViewController();
    }
    
    fileprivate func getHouseName(tmpHouseid :String) -> String {
        
        /*RESTAPIEngine.sharedEngine.createUserHomeRelation(curremail, houseId: tmpHouseid, success: { response in
            Alert.showAlertWithMessage("Successful House Creation!", fromViewController: self)
        }, failure: { error in
            NSLog("Error creating user and home relationship: \(error)")
            DispatchQueue.main.async {
                Alert.showAlertWithMessage(error.errorMessage, fromViewController: self)
                self.navigationController?.popToRootViewController(animated: true)
            }
        })*/
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        let curremail = defaults.string(forKey: kUserEmail)! as String
        var houseidtemp = ""
        var housenametemp = ""
        var houseArray:[[String]] = []
        
        RESTAPIEngine.sharedEngine.getHousesFromServerWithUserEmail(curremail, success: { response in
            let records = response!["resource"] as! JSONArray
            for recordInfo in records {
                if recordInfo["house_id"] != nil {
                    houseidtemp = recordInfo["house_id"] as! String
                    housenametemp = self.getHouseName(tmpHouseid: houseidtemp)
                    print("House ID: " + houseidtemp)
                }
            }
        }, failure: { error in
            NSLog("Server Error: \(error)")
            DispatchQueue.main.async {
                Alert.showAlertWithMessage(error.errorMessage, fromViewController: self)
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    /*fileprivate func showRequestHouseInviteViewController() {
        let MainViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateHouseViewController")
        self.present(MainViewController!, animated: true, completion: nil)
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    fileprivate func showCreateHouseViewController() {
        let createHouseViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateHouseViewController")
        self.present(createHouseViewController!, animated: true, completion: nil)
    }
    
}
