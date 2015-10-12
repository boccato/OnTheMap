//
//  ViewController.swift
//  OnTheMap
//
//  Created by Ricardo Boccato Alves on 10/11/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var edtEmail: UITextField!
    @IBOutlet weak var edtPassword: UITextField!
    
    // TODO: use and Alert View Controller to report login errors
    @IBAction func loginWithUdacity(sender: UIButton) {
        UdacityClient.sharedInstance().login(edtEmail.text!, password: edtPassword.text!) { (success, errorString) in
            if success {
                print(UdacityClient.sharedInstance().sessionID!)
            }
            else {
                let ctrl = UIAlertController(title: "Login failure.", message: errorString, preferredStyle: .Alert)
                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (_) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                ctrl.addAction(action)
                self.presentViewController(ctrl, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpWithUdacity(sender: UIButton) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
