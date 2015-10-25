//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Ricardo Boccato Alves on 10/24/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import Foundation
import  UIKit

class ListViewController: UITableViewController {
    var students: [StudentInformation] = [StudentInformation]()
    
    func loadStudentLocations() {
        students = ParseClient.sharedInstance().students
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath)
        let student = students[indexPath.row]
        cell.imageView?.image = UIImage(named: "pin")
        cell.textLabel?.text = "\(student.first) \(student.last)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let url = NSURL(string: students[indexPath.row].mediaURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
}
