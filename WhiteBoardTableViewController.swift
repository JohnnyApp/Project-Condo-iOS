//
//  WhiteBoardTableViewController.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 7/15/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

import UIKit

class WhiteBoardTableViewController: UITableViewController {

    @IBAction func Logout(_ sender: Any) {

        //Confirmation to logout -
        let logoutAlert = UIAlertController(title: "Confirm", message: "Do you want to logout.", preferredStyle: UIAlertControllerStyle.alert)
        
        logoutAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            //Confirmation = false//print("Handle Ok logic here")
            //print("NO")
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
            //Confirmation = true//print("Handle Cancel Logic here")
            RESTAPIEngine.sharedEngine.logout()
            self.showLoginViewController()
        }))
        
        present(logoutAlert, animated: true, completion: nil)
        //Confirmation to logout +
    }
    
    fileprivate func showLoginViewController() {
        let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(LoginViewController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
}
