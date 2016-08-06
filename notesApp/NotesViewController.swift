//
//  NotesViewController.swift
//  notesApp
//
//  Created by user121091 on 7/28/16.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Vars
    var miFlag: Bool = true
    var globalIndex: Int = 0;
    let notesList = [
        Note(title: "First", date: "07/31/2016 09:00 AM", geolocation: "Ajax", image: "First", message: "Details Note 1 bla bla bla"),
        Note(title: "Second", date: "08/01/2016 10:00 AM", geolocation: "Toronto", image: "Second", message: "Details Note 2 yes yes yes"),
        Note(title: "Third", date: "07/30/2016 10:00 AM", geolocation: "Vaughan", image: "Third", message: "Details Note 3 no no no")
    ]
    
    var TableArray: [String] = []
    @IBOutlet weak var MyTableVC: UITableView!
    
    
    @IBAction func btnAdd(sender: UIBarButtonItem) {
        miFlag = true
        self.performSegueWithIdentifier("go2details", sender: self)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("NotesVC")
        
        //My Custom TableView
        MyTableVC.delegate = self;
        MyTableVC.dataSource = self;
        
        //Var miFlag to check Segue if is NewNote or EditExistingOne
        miFlag = true
        
        // Do any additional setup after loading the view.
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "go2details"{
            let DetailsVC = segue.destinationViewController as! NotesDetailViewController
            
            if (miFlag){
                // User Want to ADD a NEW NOTE
                let NewTittle = "My Note Tittle"
                let newDescription = "Write here your note description:"
                DetailsVC.localTittle = NewTittle
                DetailsVC.localDescription = newDescription
            }else {
                // User Want to EDIT a NEW NOTE
                DetailsVC.localTittle = notesList[globalIndex].title
                DetailsVC.localDescription = notesList[globalIndex].message
                DetailsVC.localDate = notesList[globalIndex].date
                
            }
        }
    }//end prepareForSegue
 
    
    // Para mi TABLE VIEW
    
    
    //1
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    //2
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //3
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! TableViewCell
        
        globalIndex = indexPath.row;
        cell.tittleNote.text = notesList[indexPath.row].title
        cell.dateNote.text = notesList[indexPath.row].date
        return cell
    }
    
    //4
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        globalIndex = indexPath.row;
        print("Selected Row: --> \(globalIndex)");
        
        //Here we need to send the Segue = go2details to NotesDetailViewController to show selected Note
        miFlag = false
        self.performSegueWithIdentifier("go2details", sender: self)
        
    }
}
