//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Ricardo Boccato Alves on 10/24/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    static var students: [StudentInformation] = [StudentInformation]()
    
    var lat: Double
    var long: Double
    var first: String
    var last: String
    var mapString: String
    var mediaURL: String
    
    init(dictionary: [String : AnyObject]) {
        lat = dictionary["latitude"] as! Double
        long = dictionary["longitude"] as! Double
        first = dictionary["firstName"] as! String
        last = dictionary["lastName"] as! String
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of StudentInformation objects */
    static func fromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
    
    func toDictionary() -> [String : AnyObject] {
        var result = [String : AnyObject]()
        result["latitude"] = lat
        result["longitude"] = long
        result["firstName"] = first
        result["lastName"] = last
        result["mapString"] = mapString
        result["mediaURL"] = mediaURL
        return result
    }
}
