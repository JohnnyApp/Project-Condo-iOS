//
//  Test1ViewController.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 7/15/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

import UIKit

class Test1ViewController: UIViewController {

    @IBOutlet weak var FirstnameLbl: UILabel!
    @IBOutlet weak var LastnameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        FirstnameLbl.text = defaults.object(forKey: "firstname") as! String?
        LastnameLbl.text = defaults.object(forKey: "lastname") as! String?
        emailLbl.text = defaults.object(forKey: "email") as! String?
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
