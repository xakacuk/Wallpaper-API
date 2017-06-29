//
//  AlertMessadge.swift
//  API
//
//  Created by Евгений Бейнар on 26.06.17.
//  Copyright © 2017 Евгений Бейнар. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {

    
    
    public func showAlertMessadge() {
        
        // create the alert
        let alert = UIAlertController(title: "Error", message: "error", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


