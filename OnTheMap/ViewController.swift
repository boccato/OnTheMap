//
//  ViewController.swift
//  OnTheMap
//
//  Created by Ricardo Boccato Alves on 10/11/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBAction func loginWithUdacity(sender: UIButton) {
        UdacityClient.sharedInstance().login(tfEmail.text!, password: tfPassword.text!) { (success, errorString) in
            if success {
                print(UdacityClient.sharedInstance().sessionID!)
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert("Login failure.", message: errorString)
                })
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let ctrl = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (_) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        ctrl.addAction(action)
        self.presentViewController(ctrl, animated: true, completion: nil)
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
