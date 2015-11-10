//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by Ricardo Boccato Alves on 10/24/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit
import UIKit

class InfoPostingViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnBrowse: UIBarButtonItem!
    @IBOutlet weak var btnFindOnMap: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblWhere: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var panel: UIView!
    @IBOutlet weak var txtLink: UITextView!
    @IBOutlet weak var txtLocation: UITextView!
    
    var coordinate: CLLocationCoordinate2D!
    
    @IBAction func browseLink(sender: UIBarButtonItem) {
        if let url = NSURL(string: txtLink.text!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnTheMap(sender: UIButton) {
        // Forward geocode txtLocation.
        let geo = CLGeocoder()
        activityIndicator.startAnimating()
        geo.geocodeAddressString(txtLocation.text!, completionHandler: { (marks, error) in
            self.activityIndicator.stopAnimating()

            guard (error == nil) else {
                self.showAlert("Error finding location", message: error!.description)
                return
            }

            self.coordinate = marks![0].location?.coordinate
            
            // hide stuff
            self.btnFindOnMap.hidden = true
            self.lblWhere.hidden = true
            self.txtLocation.hidden = true

            // show stuff
            self.btnBrowse.enabled = true
            self.btnSubmit.hidden = false
            self.mapView.hidden = false
            self.txtLink.hidden = false
            
            // put location on the map
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = self.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.region = MKCoordinateRegionMake(self.coordinate, MKCoordinateSpanMake(0.1,0.1))
            
        })
    }
    
    @IBAction func submit(sender: UIButton) {
        let std = StudentInformation(dictionary: [
            "latitude":  self.coordinate.latitude,
            "longitude": self.coordinate.longitude,
            "firstName": UdacityClient.sharedInstance().firstName!,
            "lastName": UdacityClient.sharedInstance().lastName!,
            "mapString": txtLocation.text!,
            "mediaURL": txtLink.text!
        ])
        ParseClient.sharedInstance().postStudentLocation(std) { (success, error)  in
            guard success else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showAlert("Error posting student information", message: error)
                }
                return
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Removes the navigation bar border.
        navBar!.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar!.shadowImage = UIImage()
    }
}
