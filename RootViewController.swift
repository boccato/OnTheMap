//
//  RootViewController.swift
//  OnTheMap
//
//  Created by Ricardo Boccato Alves on 10/24/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UITabBarController {
    @IBAction func logout(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().logout() { (success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert("Logout failure.", message: errorString)
                })
            }
        }
    }

    @IBAction func pin(sender: UIBarButtonItem) {
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
    }
}
