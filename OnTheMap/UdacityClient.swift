//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Ricardo Boccato Alves on 10/11/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    static let BaseURL: String = "https://www.udacity.com/api/"
    
    var sessionID: String?
    var userID: String?
    var firstName: String?
    var lastName: String?
    
    func login(email: String, password: String, completionHandler: (success: Bool, errorString: String) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityClient.BaseURL + "session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody = ["udacity": ["username": email, "password": password]]
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                completionHandler(success: false, errorString: error!.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandler(success: false, errorString: "No data was returned by the request!")
                return
            }

            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                
                if let result = result as? [String:AnyObject] {
                    if let error = result["error"] as? String {
                        completionHandler(success: false, errorString: error)
                    }
                    else {
                        if let account = result["account"] as? [String:AnyObject] {
                            if let uid = account["key"] as? String {
                                self.userID = uid
                            }
                        }
                        if let session = result["session"] as? [String:AnyObject] {
                            if let sid = session["id"] as? String {
                                self.sessionID = sid
                            }
                        }
                        self.getUserData(completionHandler)
                    }
                }
            } catch {
                completionHandler(success: false, errorString: "Could not parse the data as JSON: '\(newData)'")
            }
            
        }
        task.resume()
    }
    
    func logout(completionHandler: (success: Bool, errorString: String) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityClient.BaseURL + "session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if let cookies = sharedCookieStorage.cookies {
            for cookie in cookies {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil else {
                completionHandler(success: false, errorString: "There was an error with your request: \(error)")
                return
            }
            self.userID = nil
            self.sessionID = nil
            self.firstName = nil
            self.lastName = nil
            completionHandler(success: true, errorString: "")
        }
        task.resume()
    }

    func getUserData(completionHandler: (success: Bool, errorString: String) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityClient.BaseURL + "users/" + userID!)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                completionHandler(success: false, errorString: error!.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandler(success: false, errorString: "No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                
                if let result = result as? [String:AnyObject] {
                    if let error = result["error"] as? String {
                        completionHandler(success: false, errorString: error)
                    }
                    else {
                        if let user = result["user"] as? [String:AnyObject] {
                            if let first_name = user["first_name"] as? String {
                                self.firstName = first_name
                            }
                            if let last_name = user["last_name"] as? String {
                                self.lastName = last_name
                            }
                        }
                        completionHandler(success: true, errorString: "")
                    }
                }
            } catch {
                completionHandler(success: false, errorString: "Could not parse the data as JSON: '\(newData)'")
            }
        }
        task.resume()
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
