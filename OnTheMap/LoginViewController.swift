//
//  ViewController.swift
//  OnTheMap
//
//  Created by Ricardo Boccato Alves on 10/11/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBAction func loginWithUdacity(sender: UIButton) {
        UdacityClient.sharedInstance().login(tfEmail.text!, password: tfPassword.text!) { (success, errorString) in
            if success {
                //print(UdacityClient.sharedInstance().sessionID!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("map", sender: self)
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert("Login failure.", message: errorString)
                })
            }
        }
    }
    
    @IBAction func signUpWithUdacity(sender: UIButton) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == tfEmail {
            tfPassword.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }

}
