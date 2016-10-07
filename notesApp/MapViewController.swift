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

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Vars
    var addressString: String = ""
    var locations = [MKPlacemark]()
    var note = Note()
    let rootKey = "rootKey"
    var globalIndex: Int = 0;
    /*let notesList = [
        Note(title: "First", date: "07/31/2016 09:00 AM", geolocation: "Ajax", image: "First", message: "Details Note 1 bla bla bla"),
        Note(title: "Second", date: "08/01/2016 10:00 AM", geolocation: "Toronto", image: "Second", message: "Details Note 2 yes yes yes"),
        Note(title: "Third", date: "07/30/2016 10:00 AM", geolocation: "Vaughan", image: "Third", message: "Details Note 3 no no no")
    ]*/
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var MyTableVC: UITableView!
    
    
    func addMap(addNote: Note) {
      
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addNote.geolocation,completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if (placemarks?.count > 0) {
                let first: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: first)
                self.locations.append(placemark)
                    
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placemark.location?.coordinate)!
                annotation.title = "\(addNote.title) in \(addNote.geolocation) at \(addNote.date)"
                        
                var region: MKCoordinateRegion = self.map.region
                region.center.latitude = (placemark.location?.coordinate.latitude)!
                region.center.longitude = (placemark.location?.coordinate.longitude)!
                        
                region.span = MKCoordinateSpanMake(0.5, 0.5)

                self.map.addAnnotation(annotation)
            }
        })

        
    }
    
    func dataFileURL() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!.URLByAppendingPathComponent("data.archive")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getNote()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //My Custom TableView
        MyTableVC.delegate = self;
        MyTableVC.dataSource = self;
        
        
        self.getNote()
        
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self,
        selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)),
        name: UIApplicationWillResignActiveNotification, object: app)

        //let geocoder: CLGeocoder = CLGeocoder()
        
        /*geocoder.geocodeAddressString("Toronto",completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if (placemarks?.count > 0) {
                let first: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: first)
                //self.locations.append(placemark)
                
                var region: MKCoordinateRegion = self.map.region
                region.center.latitude = (placemark.location?.coordinate.latitude)!
                region.center.longitude = (placemark.location?.coordinate.longitude)!
                
                region.span = MKCoordinateSpanMake(0.5, 0.5)
                
                self.map.setRegion(region, animated: true)
            }
        })*/
        self.locations.removeAll()
        self.map.removeAnnotations(self.map.annotations)
        for noteItem in note.notesList {
            addMap(noteItem)
        }
        print("Printing all elements in ** note.noteList (Array) in ViewDidLoad **")
        print("------RESULT-----")
        dump(note.notesList)
        
    }
    
    func updateNote()
    {
        let fileURL = self.dataFileURL()
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(note, forKey: rootKey)
        archiver.finishEncoding()
        data.writeToURL(fileURL, atomically: true)
    }
    
    func getNote() {
        let fileURL = self.dataFileURL()
        if (NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!)) {
            let data = NSMutableData(contentsOfURL: fileURL)!
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            note = unarchiver.decodeObjectForKey(rootKey) as! Note
            unarchiver.finishDecoding()
            self.MyTableVC.reloadData()
            self.locations.removeAll()
            self.map.removeAnnotations(self.map.annotations)
            for noteItem in note.notesList {
                addMap(noteItem)
            }
            
        }
    }
    
    func applicationWillResignActive(notification:NSNotification) {
        let fileURL = self.dataFileURL()
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(note, forKey: rootKey)
        archiver.finishEncoding()
        data.writeToURL(fileURL, atomically: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Para mi TABLE VIEW
    
    
    //1
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(note.notesList.count)
        return note.notesList.count
    }
    
    //2
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //3
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! TableMapViewCell
        
        globalIndex = indexPath.row;
        cell.tittleNote.text = note.notesList[indexPath.row].title
        cell.locationNote.text = note.notesList[indexPath.row].geolocation
        return cell
    }
    
    //4
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        globalIndex = indexPath.row;
        print("Selected Row: --> \(indexPath.row)");
        
        //let alertController = UIAlertController(title: "Note: \(note.notesList[indexPath.row].title)", message: "Location: \(note.notesList[indexPath.row].geolocation) \n Date: \(note.notesList[indexPath.row].date) \n Image: \(note.notesList[indexPath.row].image)", preferredStyle: .Alert)
        
        //let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        //alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(note.notesList[indexPath.row].geolocation,completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
         if (placemarks?.count > 0) {
            let first: CLPlacemark = (placemarks?[0])!
            let placemark: MKPlacemark = MKPlacemark(placemark: first)
            //self.locations.append(placemark)
         
            var region: MKCoordinateRegion = self.map.region
            region.center.latitude = (placemark.location?.coordinate.latitude)!
            region.center.longitude = (placemark.location?.coordinate.longitude)!
         
            region.span = MKCoordinateSpanMake(0.5, 0.5)
         
            self.map.setRegion(region, animated: true)
         }
         })
        
        //var region: MKCoordinateRegion = self.map.region
        //region.center.latitude = (location.coordinate.latitude)
        //region.center.longitude = (location.coordinate.longitude)
        
        //region.span = MKCoordinateSpanMake(0.5, 0.5)
        
        //self.map.setRegion(region, animated: true)
        //self.map.selectAnnotation(map.annotations[indexPath.row], animated: true)
        //Here we need to send the Segue = go2details to NotesDetailViewController to show selected Note
        
    }
    
}
