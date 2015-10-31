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
    
    @IBOutlet weak var btnFindOnMap: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblWhere: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var panel: UIView!
    @IBOutlet weak var txtLink: UITextView!
    @IBOutlet weak var txtLocation: UITextView!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnTheMap(sender: UIButton) {
        // Forward geocode txtLocation.
        let geo = CLGeocoder()
        geo.geocodeAddressString(txtLocation.text!, completionHandler: { (marks, error) in
            guard (error == nil) else {
                self.showAlert("Error finding location", message: error!.description)
                return
            }
            
            // hide stuff
            self.btnFindOnMap.hidden = true
            self.lblWhere.hidden = true
            self.txtLocation.hidden = true

            // show stuff
            self.btnSubmit.hidden = false
            self.mapView.hidden = false
            self.txtLink.hidden = false
            
            // put location on the map
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = (marks![0].location?.coordinate)!
            self.mapView.addAnnotation(annotation)
        })
    }
    
    @IBAction func submit(sender: UIButton) {
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Removes the navigation bar border.
        navBar!.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar!.shadowImage = UIImage()
    }
    
}
