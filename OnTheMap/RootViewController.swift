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
        ParseClient.sharedInstance().load() { (students, error) in
            dispatch_async(dispatch_get_main_queue(), {
                guard let students = students else {
                    self.showAlert("Error loading data.", message: error)
                    return
                }
                self.appDelegate().students = students
                for ctrl in self.viewControllers! {
                    if let ctrl = ctrl as? MapViewController {
                        ctrl.loadStudentLocations()
                    }
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
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        load()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
}
