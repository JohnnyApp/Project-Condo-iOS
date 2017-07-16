//
//  UserInterface.swift
//  ProjectCondo-Beta_V2
//
//  Created by jonathan laroco on 6/25/17.
//  Copyright © 2017 jonathan laroco. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static func showAlertWithMessage(_ message: String, fromViewController vc: UIViewController) {
        let alert = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}
