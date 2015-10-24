//
//  Util.swift
//  OnTheMap
//
//  Created by Ricardo Boccato Alves on 10/24/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (_) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
