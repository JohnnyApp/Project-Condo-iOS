//
//  HousesTableViewController.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 8/11/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

import UIKit

class HousesTableViewController: UITableViewController, HomesDelegate{
    
    fileprivate var homeArray2: [String:String] = [:]
    fileprivate var houseArrayTemp: [String]!
    fileprivate var currentHomes:HomeRecord? = nil
    fileprivate let dataAccess = DataAccess.sharedInstance
    fileprivate var homes = [HomeRecord]()

    @IBAction func OpenCreateHouse(_ sender: Any) {
        showCreateHouseViewController();
    }
    @IBAction func test(_ sender: Any) {
        getHouseDataPerUser()
        data.removeAll()
        for (key,value) in self.homeArray2 {
            print("Key: " + key + " Name:" + value)
            data.append(value)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.removeAll()
        //getHouseDataPerUser()
        tableView.dataSource = self
        
        //if dataAccess.isSignedIn() {
            reloadHomesForUser(currentHomes)
        //}
        
    }
    private var data: [String] = []
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell")! //1.
        
        let text = data[indexPath.row] //2.
        
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
    
    fileprivate func reloadHomesForUser(_ homes:HomeRecord?) {
        currentHomes = homes
        let defaults = UserDefaults.standard
        let curremail = defaults.string(forKey: kUserEmail)! as String
        dataAccess.getHomes(currentHomes, email: curremail, resultDelegate: self)
    }
    
    //Homes Delegate
    func setHomes(_ homes: [HomeRecord]) {
        self.homes = homes
        
        /*for home in homes {
            //let homename = home.houseName
            //let firstChar = String(describing: homename?.prefix(1))
        }*/
        tableView.setContentOffset(CGPoint.zero, animated: true)
        tableView.reloadData()
    }
    
    func dataAccessError(_ error: NSError?) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    fileprivate func showCreateHouseViewController() {
        let createHouseViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateHouseViewController")
        self.present(createHouseViewController!, animated: true, completion: nil)
    }
    fileprivate func getHouseDataPerUser() {
        let defaults = UserDefaults.standard
        let curremail = defaults.string(forKey: kUserEmail)! as String
        
        self.houseArrayTemp = []
        
        RESTAPIEngine.sharedEngine.getHouseIDArray(curremail) {strings, error in
            for str in strings! {
                self.houseArrayTemp.append(str)
            }
            
            for tmp in self.houseArrayTemp {
                RESTAPIEngine.sharedEngine.getHouseNameArray(tmp) {strings, error in
                    self.homeArray2.updateValue(strings!, forKey: tmp)
                }
            }
            
        }
    }
    
}
