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
    var sortNote = [Note] ()
    let rootKey = "rootKey"

    //Search Bar
    var filteredTittle = [Note] ()
    var searchActive = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    //TableView
    var TableArray: [String] = []
    @IBOutlet weak var MyTableVC: UITableView!
    
    @IBAction func btnOrderBy(sender: UIBarButtonItem) {

        let actionSheetController: UIAlertController = UIAlertController(title: "Sort By...", message: "", preferredStyle: .ActionSheet)
        

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Cancel
        }
        actionSheetController.addAction(cancelAction)
        

        let sortByTittleAZ: UIAlertAction = UIAlertAction(title: "Tittle (A-Z)", style: .Default) { action -> Void in
            //Tittle
            self.note.notesList.sortInPlace({ $0.title < $1.title })
            self.MyTableVC.reloadData();
        }
        actionSheetController.addAction(sortByTittleAZ)
        
        let sortByTittleZA: UIAlertAction = UIAlertAction(title: "Tittle (Z-A)", style: .Default) { action -> Void in
            //Tittle
            self.note.notesList.sortInPlace({ $0.title > $1.title })
            self.MyTableVC.reloadData();
        }
        actionSheetController.addAction(sortByTittleZA)

        let sortByNewestSaved: UIAlertAction = UIAlertAction(title: "Newest Saved", style: .Default) { action -> Void in
            //sortNewestSaved
            self.note.notesList.sortInPlace({ $0.date > $1.date })
            self.MyTableVC.reloadData();
        }
        actionSheetController.addAction(sortByNewestSaved)
        
        let sortByOldestSaved: UIAlertAction = UIAlertAction(title: "Oldest Saved", style: .Default) { action -> Void in
            //sortByOldestSaved
            self.note.notesList.sortInPlace({ $0.date < $1.date })
            self.MyTableVC.reloadData();
        }
        actionSheetController.addAction(sortByOldestSaved)
        
        let sortByLongest: UIAlertAction = UIAlertAction(title: "Longest Notes", style: .Default) { action -> Void in
            //sortByLongest
            self.note.notesList.sortInPlace({ $0.message < $1.message })
            self.MyTableVC.reloadData();
        }
        actionSheetController.addAction(sortByLongest)
        
        let sortByShortest: UIAlertAction = UIAlertAction(title: "Shortest Notes", style: .Default) { action -> Void in
            //sortByShortest
            self.note.notesList.sortInPlace({ $0.message > $1.message })
            self.MyTableVC.reloadData();
        }
        actionSheetController.addAction(sortByShortest)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnAdd(sender: UIBarButtonItem) {
        self.globalIndex = -1
        updateNote()
        self.performSegueWithIdentifier("go2details", sender: self)
    }
    
    func dataFileURL() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!.URLByAppendingPathComponent("data.archive")
    }
    
    override func viewWillAppear(animated: Bool) {
        getNote()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print ("NotesVC")
        
        getNote()
        
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self,
        selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)),
        name: UIApplicationWillResignActiveNotification, object: app)
        
        if (note.notesList.count==0) {
            print("inserting data")
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
        
        //Search Bar
        searchBar.delegate = self
    
        
        // Do any additional setup after loading the view.
    }
    
    func getNote() {
        let fileURL = self.dataFileURL()
        if (NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!)) {
            let data = NSMutableData(contentsOfURL: fileURL)!
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            note = unarchiver.decodeObjectForKey(rootKey) as! Note
            unarchiver.finishDecoding()
            self.MyTableVC.reloadData()
        }
    }
    
    func applicationWillResignActive(notification:NSNotification!) {
        updateNote()
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

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "go2details"{
            updateNote()
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
            cell.lblMessage.text = filteredTittle[indexPath.row].message
            cell.dateNote.text = filteredTittle[indexPath.row].date
        }else
        {
            cell.tittleNote.text = note.notesList[indexPath.row].title
            cell.lblMessage.text = note.notesList[indexPath.row].message
            cell.dateNote.text = note.notesList[indexPath.row].date
            
        }

        return cell
    }
    
    //4
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        globalIndex = indexPath.row;
        print("Selected Row: --> \(globalIndex)");
        updateNote()
        
        //Here we need to send the Segue = go2details to NotesDetailViewController to show selected Note
        self.performSegueWithIdentifier("go2details", sender: self)
        
    }
    
    //5 To remore from table View
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let delNote = note.notesList[indexPath.row]
            
            let alertController = UIAlertController(title: delNote.title, message: "Would you like to delete actual note ?", preferredStyle: .Alert)
            
            let actionYes = UIAlertAction(title: "Ok", style: .Default) { (action:UIAlertAction) in
                print("---YES delete!!!---");
                self.updateNote()
                //Here remove from DB
                //print("----------BEFORE-------------")
                //dump(self.note.notesList)
                
                self.note.notesList.removeAtIndex(indexPath.row)
                
                //print("----------AFTER-------------")
                //dump(self.note.notesList)
                
                self.MyTableVC.reloadData();
            }
            
            let actionNo = UIAlertAction(title: "No", style: .Default) { (action:UIAlertAction) in
                print("--NO Abort--");
            }
            
            alertController.addAction(actionYes)
            alertController.addAction(actionNo)
            self.presentViewController(alertController, animated: true, completion:nil)
            
            
            //MyTableVC.reloadData();

        }
        
    }
    
    //6 To Enable DELETE from table View
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    //Search Bar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //print("Get into Search Bar")
        if(searchBar.text!.isEmpty) {
            self.searchActive = false
        } else {
            filteredTittle.removeAll(keepCapacity: false)
<<<<<<< HEAD
            for (var index=0; index < note.notesList.count; index++) {
                //We need to search for Tittle or inside the Message
=======
            for (var index=0; index < note.notesList.count; index+=1) {
>>>>>>> origin/master
                let myTittle = note.notesList[index].title
                let myMessage = note.notesList[index].message
                if(myTittle.lowercaseString.rangeOfString(searchText.lowercaseString) != nil || myMessage.lowercaseString.rangeOfString(searchText.lowercaseString) != nil ){
                    filteredTittle.append(note.notesList[index]);
                    self.searchActive = true
                }
            }
        }
        
        self.MyTableVC.reloadData()
    }//end searchBar
    
    
}





