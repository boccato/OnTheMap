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
    var first_name: String?
    var last_name: String?
    
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
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                completionHandler(success: false, errorString: "There was an error with your request: \(error)")
                return
            }

            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                var msg: String = ""
                if let response = response as? NSHTTPURLResponse {
                    msg = "Your request returned an invalid response! Status code: \(response.statusCode)!"
                } else if let response = response {
                    msg = "Your request returned an invalid response! Response: \(response)!"
                } else {
                    msg = "Your request returned an invalid response!"
                }
                completionHandler(success: false, errorString: msg)
                return
            }

            // GUARD: Was there any data returned?
            guard let data = data else {
                completionHandler(success: false, errorString: "No data was returned by the request!")
                return
            }

            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                // GUARD: Did we find a session id?
                guard let sid = ((result as? [String: AnyObject])?["session"] as? [String: AnyObject])?["id"] as? String else {
                    return
                }
                self.sessionID = sid
                // GUARD: Did we find a user id?
                guard let uid = ((result as? [String: AnyObject])?["account"] as? [String: AnyObject])?["key"] as? String else {
                    return
                }
                self.userID = uid
                self.getUserData(completionHandler)
            } catch {
                completionHandler(success: false, errorString: "Could not parse the data as JSON: '\(data)'")
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
            self.sessionID = nil
            completionHandler(success: true, errorString: "")
        }
        task.resume()
    }

    func getUserData(completionHandler: (success: Bool, errorString: String) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityClient.BaseURL + "users/" + userID!)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil else {
                completionHandler(success: false, errorString: "\(error)")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                completionHandler(success: false, errorString: "No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                guard let first = ((result as? [String: AnyObject])?["user"] as? [String: AnyObject])?["first_name"] as? String else {
                    return
                }
                self.first_name = first
                guard let second = ((result as? [String: AnyObject])?["user"] as? [String: AnyObject])?["last_name"] as? String else {
                    return
                }
                self.last_name = second
                completionHandler(success: true, errorString: "")
            } catch {
                completionHandler(success: false, errorString: "Could not parse the data as JSON: '\(data)'")
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
