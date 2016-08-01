//
//  MapViewController.swift
//  notesApp
//
//  Created by user121091 on 7/28/16.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    //Vars
    var addressString: String = ""
    var locations = [MKPlacemark]()
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func btnAddPlace(sender: UIButton) {
        addressString = address.text!
        address.text = ""
        
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressString,completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if (placemarks?.count > 0) {
                if (self.locations.count >= 3) {
                    let alert = UIAlertController(title: "Error", message: "You cannot add more locations", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let first: CLPlacemark = (placemarks?[0])!
                    let placemark: MKPlacemark = MKPlacemark(placemark: first)
                    self.locations.append(placemark)
                    
                    
                    switch self.locations.count  {
                    case 1:
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = (placemark.location?.coordinate)!
                        annotation.title = "A"
                        
                        var region: MKCoordinateRegion = self.map.region
                        region.center.latitude = (placemark.location?.coordinate.latitude)!
                        region.center.longitude = (placemark.location?.coordinate.longitude)!
                        
                        region.span = MKCoordinateSpanMake(0.5, 0.5)
                        
                        self.map.setRegion(region, animated: true)
                        self.map.addAnnotation(annotation)
                        
                        break
                    case 2:
                        
                        self.map.removeAnnotations(self.map.annotations)
                        
                        let annotationA = MKPointAnnotation()
                        annotationA.coordinate = (self.locations[0].location?.coordinate)!
                        annotationA.title = "A"
                        let distanceAB = (self.locations[0].location!.distanceFromLocation(self.locations[1].location!))/1000
                        let roundeDistanceAB = Double(round(100*distanceAB)/100)
                        annotationA.subtitle = "A to B: \(roundeDistanceAB)Kms"
                        
                        var regionA: MKCoordinateRegion = self.map.region
                        regionA.center.latitude = (placemark.location?.coordinate.latitude)!
                        regionA.center.longitude = (placemark.location?.coordinate.longitude)!
                        
                        regionA.span = MKCoordinateSpanMake(0.5, 0.5)
                        
                        self.map.setRegion(regionA, animated: true)
                        self.map.addAnnotation(annotationA)
                        
                        let annotationB = MKPointAnnotation()
                        annotationB.coordinate = (placemark.location?.coordinate)!
                        annotationB.title = "B"
                        let distanceBA = (self.locations[1].location!.distanceFromLocation(self.locations[0].location!))/1000
                        let roundeDistanceBA = Double(round(100*distanceBA)/100)
                        annotationB.subtitle = "B to A: \(roundeDistanceBA)Kms"
                        
                        var regionB: MKCoordinateRegion = self.map.region
                        regionB.center.latitude = (placemark.location?.coordinate.latitude)!
                        regionB.center.longitude = (placemark.location?.coordinate.longitude)!
                        
                        regionB.span = MKCoordinateSpanMake(0.5, 0.5)
                        
                        self.map.setRegion(regionB, animated: true)
                        self.map.addAnnotation(annotationB)
                        
                        break
                    case 3:
                        
                        self.map.removeAnnotations(self.map.annotations)
                        
                        let annotationA = MKPointAnnotation()
                        annotationA.coordinate = (self.locations[0].location?.coordinate)!
                        annotationA.title = "A"
                        let distanceAB = (self.locations[0].location!.distanceFromLocation(self.locations[1].location!))/1000
                        let roundeDistanceAB = Double(round(100*distanceAB)/100)
                        let distanceAC = (self.locations[0].location!.distanceFromLocation(self.locations[2].location!))/1000
                        let roundeDistanceAC = Double(round(100*distanceAC)/100)
                        annotationA.subtitle = "A to B: \(roundeDistanceAB)Kms - A to C: \(roundeDistanceAC)Kms"
                        
                        var regionA: MKCoordinateRegion = self.map.region
                        regionA.center.latitude = (placemark.location?.coordinate.latitude)!
                        regionA.center.longitude = (placemark.location?.coordinate.longitude)!
                        
                        regionA.span = MKCoordinateSpanMake(0.5, 0.5)
                        
                        self.map.setRegion(regionA, animated: true)
                        self.map.addAnnotation(annotationA)
                        
                        let annotationB = MKPointAnnotation()
                        annotationB.coordinate = (self.locations[1].location?.coordinate)!
                        annotationB.title = "B"
                        let distanceBA = (self.locations[1].location!.distanceFromLocation(self.locations[0].location!))/1000
                        let roundeDistanceBA = Double(round(100*distanceBA)/100)
                        let distanceBC = (self.locations[1].location!.distanceFromLocation(self.locations[2].location!))/1000
                        let roundeDistanceBC = Double(round(100*distanceBC)/100)
                        annotationB.subtitle = "B to A: \(roundeDistanceBA)Kms - B to C: \(roundeDistanceBC)Kms"
                        
                        var regionB: MKCoordinateRegion = self.map.region
                        regionB.center.latitude = (placemark.location?.coordinate.latitude)!
                        regionB.center.longitude = (placemark.location?.coordinate.longitude)!
                        
                        regionB.span = MKCoordinateSpanMake(0.5, 0.5)
                        
                        self.map.setRegion(regionB, animated: true)
                        self.map.addAnnotation(annotationB)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = (placemark.location?.coordinate)!
                        annotation.title = "C"
                        let distanceCA = (self.locations[2].location!.distanceFromLocation(self.locations[0].location!))/1000
                        let roundeDistanceCA = Double(round(100*distanceCA)/100)
                        let distanceCB = (self.locations[2].location!.distanceFromLocation(self.locations[1].location!))/1000
                        let roundeDistanceCB = Double(round(100*distanceCB)/100)
                        annotation.subtitle = "C to A: \(roundeDistanceCA)Kms - C to B: \(roundeDistanceCB)Kms"
                        
                        var region: MKCoordinateRegion = self.map.region
                        region.center.latitude = (placemark.location?.coordinate.latitude)!
                        region.center.longitude = (placemark.location?.coordinate.longitude)!
                        
                        region.span = MKCoordinateSpanMake(0.5, 0.5)
                        
                        self.map.setRegion(region, animated: true)
                        self.map.addAnnotation(annotation)
                        
                        break
                    default:
                        break
                    }
                    
                    
                    
                }
            }
        })

        
    }//end btnAddPlace

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
