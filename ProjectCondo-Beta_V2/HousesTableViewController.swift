//
//  HousesTableViewController.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 8/11/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

import UIKit

class HousesTableViewController: UITableViewController {    
    fileprivate var homeArray2: [String:String] = [:]
    fileprivate var houseArrayTemp: [String]!
    
    @IBAction func OpenCreateHouse(_ sender: Any) {
        showCreateHouseViewController();
    }
    @IBAction func test(_ sender: Any) {
        for (key,value) in self.homeArray2 {
            print("Key: " + key + " Name:" + value)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        let curremail = defaults.string(forKey: kUserEmail)! as String
        
        self.houseArrayTemp = []
        
        RESTAPIEngine.sharedEngine.getHouseIDArray(curremail) {strings, error in
            for str in strings! {
                self.houseArrayTemp.append(str)
            }
            
            for tmp in self.houseArrayTemp {
                //print("Test: " + tmp)
                RESTAPIEngine.sharedEngine.getHouseNameArray(tmp) {strings, error in
                    self.homeArray2.updateValue(strings!, forKey: tmp)
                }
            }

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
