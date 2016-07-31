//
//  NotesViewController.swift
//  notesApp
//
//  Created by user121091 on 7/28/16.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    //Vars
    
    @IBAction func btnAdd(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("go2details", sender: self)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("NotesVC")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "go2details"{
            let DetailsVC = segue.destinationViewController as! NotesDetailViewController
            var xValue = "My New Note"
            DetailsVC.localVar = xValue
        
        }
        
        
        
        
    }
 

}
