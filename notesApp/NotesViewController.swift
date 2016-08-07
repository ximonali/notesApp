//
//  NotesViewController.swift
//  notesApp
//
//  Created by user121091 on 7/28/16.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {

    //Vars
    var globalIndex: Int = -1
    var note = Note()
    let rootKey = "rootKey"

    //Search Bar
    var filteredTittle = [Note] ()
    var searchActive = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    //TableView
    var TableArray: [String] = []
    @IBOutlet weak var MyTableVC: UITableView!
    
    
    @IBAction func btnAdd(sender: UIBarButtonItem) {
        self.globalIndex = -1
        self.performSegueWithIdentifier("go2details", sender: self)
    }
    
    func dataFileURL() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!.URLByAppendingPathComponent("data.archive")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print ("NotesVC")
        
        let fileURL = self.dataFileURL()
        if (NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!)) {
            let data = NSMutableData(contentsOfURL: fileURL)!
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            note = unarchiver.decodeObjectForKey(rootKey) as! Note
            unarchiver.finishDecoding()
        }
        
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)),
            name: UIApplicationWillResignActiveNotification,
            object: app)
        
        if (note.notesList.count==0) {
            let Note1 = Note(title: "First", date: "07/31/2016 09:00 AM", geolocation: "Ajax", image: "First", message: "Details Note 1 bla bla bla")
            let Note2 = Note(title: "Second", date: "08/01/2016 10:00 AM", geolocation: "Toronto", image: "Second", message: "Details Note 2 yes yes yes")
            let Note3 = Note(title: "Third", date: "07/30/2016 10:00 AM", geolocation: "Vaughan", image: "Third", message: "Details Note 3 no no no")
            note.notesList.append(Note1)
            note.notesList.append(Note2)
            note.notesList.append(Note3)
        }
        
        //My Custom TableView
        MyTableVC.delegate = self;
        MyTableVC.dataSource = self;
    
        
        // Do any additional setup after loading the view.
    }
    
    func applicationWillResignActive(notification:NSNotification) {
        let fileURL = self.dataFileURL()
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(note, forKey: rootKey)
        archiver.finishEncoding()
        data.writeToURL(fileURL, atomically: true)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "go2details"{
            let DetailsVC = segue.destinationViewController as! NotesDetailViewController
            DetailsVC.globalIndex = self.globalIndex
        }
    }//end prepareForSegue
 
    
    // Para mi TABLE VIEW
    
    
    //1
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var countNum = 0;
        if searchActive {
            countNum = filteredTittle.count
        }else
        {
            countNum = note.notesList.count
        }
        return countNum
    }
    
    //2
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //3
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! TableViewCell
        
        globalIndex = indexPath.row;
        
        if searchActive {
            cell.tittleNote.text = filteredTittle[indexPath.row].title
            cell.dateNote.text = filteredTittle[indexPath.row].date
        }else
        {
            cell.tittleNote.text = note.notesList[indexPath.row].title
            cell.dateNote.text = note.notesList[indexPath.row].date
            
        }

        return cell
    }
    
    //4
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        globalIndex = indexPath.row;
        print("Selected Row: --> \(globalIndex)");
        
        //Here we need to send the Segue = go2details to NotesDetailViewController to show selected Note
        self.performSegueWithIdentifier("go2details", sender: self)
        
    }
    
    //5 To remore from table View
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var delNote = note.notesList[indexPath.row]
            
            print("Note to be Deleted: \(delNote.title) \(delNote.date)")
            
            let alertController = UIAlertController(title: delNote.title, message: "Would you like to delete actual note ?", preferredStyle: .Alert)
            
            let actionYes = UIAlertAction(title: "Ok", style: .Default) { (action:UIAlertAction) in
                print("---YES delete!!!---");
                //Here remove from DB
                self.note.notesList.removeAtIndex(indexPath.row)
            }
            
            let actionNo = UIAlertAction(title: "No", style: .Default) { (action:UIAlertAction) in
                print("--NO Abort--");
            }
            
            alertController.addAction(actionYes)
            alertController.addAction(actionNo)
            self.presentViewController(alertController, animated: true, completion:nil)
            
            
            MyTableVC.reloadData();

        }
        
    }
    
    //6 To Enable DELETE from table View
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    //Search Bar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text!.isEmpty) {
            self.searchActive = false
        } else {
            filteredTittle.removeAll(keepCapacity: false)
            for (var index=0; index < note.notesList.count; index++) {
                let myTittle = note.notesList[index].title
                //Here We MUST add the description FIELD
                if(myTittle.lowercaseString.rangeOfString(searchText.lowercaseString) != nil ){
                    filteredTittle.append(note.notesList[index]);
                    self.searchActive = true
                }
            }
        }
        
        self.MyTableVC.reloadData()
    }//end searchBar
    
    
}





