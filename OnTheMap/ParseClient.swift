//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Ricardo Boccato Alves on 10/20/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    let BASE_URL = "https://api.parse.com/1/classes/StudentLocation"
    
    func load(completionHandler: (students: [StudentInformation]?, error: String) -> Void) {
        let params = ["limit": 100, "order": "-updatedAt"]
        let urlString = BASE_URL + escapedParameters(params)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil else {
                completionHandler(students: nil, error: error!.localizedDescription)
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
                completionHandler(students: nil, error: msg)
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                completionHandler(students: nil, error: "No data was returned by the request!")
                return
            }
            
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                // GUARD: Did we find a session id?
                guard let locs = (result as? [String: AnyObject])?["results"] as? [[String: AnyObject]] else {
                    return
                }
                completionHandler(students: StudentInformation.fromResults(locs), error: "")
            } catch {
                completionHandler(students: nil, error: "Could not parse the data as JSON: '\(data)'")
            }
        }
        task.resume()
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    func postStudentLocation(std: StudentInformation, completionHandler: (success: Bool, error: String) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL)!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var params = std.toDictionary()
        params["uniqueKey"] = UdacityClient.sharedInstance().userID
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil else {
                completionHandler(success: false, error: "\(error)")
                return
            }
            // GUARD: Was there any data returned?
            guard let data = data else {
                completionHandler(success: false, error: "No data was returned by the request!")
                return
            }
            
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                guard ((result as? [String: AnyObject])?["createdAt"] as? String) != nil else {
                    completionHandler(success: true, error: "Could not create student information: '\(result)")
                    return
                }
                completionHandler(success: true, error: "")
            } catch {
                completionHandler(success: false, error: "Could not parse the data as JSON: '\(data)'")
            }            
        }
        task.resume()
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
