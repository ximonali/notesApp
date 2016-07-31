//
//  NoteViewController.swift
//  notesApp
//
//  Created by user121091 on 7/31/16.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit
import MobileCoreServices

class NotesDetailViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    //Vars
    var localVar: String = "";
    
    
    //------ Vars for camera
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takePictureButton: UIButton!
    var newMedia: Bool?

    //------
    
    
    @IBOutlet weak var txtTittle: UITextField!
    
    @IBAction func btnAddPicture(sender: UIButton) {
        
    }
    
    @IBAction func selectPicture(sender: UIButton) {
        
    }
    
    
    @IBAction func btnSave(sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("NotesDetailsVC")
        
        txtTittle.text = localVar
        cameraSettings()

    }

    func cameraSettings() {
        // Check if my device has camera or not
        if !UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            takePictureButton.hidden = true
        }
    }
    
  


    
    

    

}
