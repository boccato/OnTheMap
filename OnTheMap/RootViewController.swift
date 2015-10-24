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

    func load() {
        ParseClient.sharedInstance().load() { (success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    NSNotificationCenter.defaultCenter().postNotificationName("StudentLocationsLoaded", object: nil)
                }
                else {
                    self.showAlert("Error loading data.", message: errorString)
                }
            })
        }
    }
    
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
        load()
    }
    
    override func viewWillAppear(animated: Bool) {
        load()
        super.viewWillAppear(animated)
    }
}
