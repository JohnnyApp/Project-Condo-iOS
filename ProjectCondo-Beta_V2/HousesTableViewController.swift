//
//  HousesTableViewController.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 8/11/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

import UIKit

class HousesTableViewController: UITableViewController {
    var test1 = ""
    
    // Used to hold house Array's
    fileprivate var houseArray: [[String]]!
    fileprivate var houseArrayTemp: [String]!
    
    @IBAction func OpenCreateHouse(_ sender: Any) {
        showCreateHouseViewController();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        let curremail = defaults.string(forKey: kUserEmail)! as String
        
        self.houseArrayTemp = []
        
        var houseidtemp = ""
        //var housenametemp = ""
        //var houseArray: [String: String] = ["": ""]
        
        RESTAPIEngine.sharedEngine.getHouseIDArray(curremail) {strings, error in
            //THIS SHIT RUNS FIRST
            //DO SHIT WITH STRINGS HERE...
            for str in strings! {
                houseidtemp = houseidtemp + "," + str
                self.houseArrayTemp.append(str)
                print("INDIVIDUAL STRINGS HERE: " + str)
            }
        print(self.houseArrayTemp)
        }
        //THEN THIS SHIT...
    }

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
