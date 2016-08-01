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
    var notesArray: [String] = ["First","Second","Third","fourth","Fifth","More..."]
    var notesDate: [String] = ["5:45 PM","07/31/2016","07/31/2016","07/30/2016","07/25/2016","More..."]
    var notesDetails: [String] = ["Destails Note 1 Bla bla...","Details Note 2 yes yes yes ","Details Note 3 No no no","Details Note 4 yafdiailudhf","Details Note 5 andosdlsjdljsdjsd","Details Note More..."]
    var pictureArray:[String] = ["First","Second","Third","fourth","Fifth","More..."]
    var pictureLocationArray: [String] = ["London","Toronto","Rio","Caracas","Scarborough","More..."]
    
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
                DetailsVC.localTittle = notesArray[globalIndex]
                DetailsVC.localDescription = notesDetails[globalIndex]
                DetailsVC.localDate = notesDate[globalIndex]
                
            }
        
        }
    }//end prepareForSegue
 
    
    // Para mi TABLE VIEW
    
    
    //1
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    //2
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //3
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! TableViewCell
        
        globalIndex = indexPath.row;
        cell.tittleNote.text = notesArray[indexPath.row]
        cell.dateNote.text = notesDate[indexPath.row]
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
