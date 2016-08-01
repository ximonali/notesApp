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
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var pickMyPicture: UIButton!


    
    
    @IBOutlet weak var txtTittle: UITextField!
    
    
    @IBAction func btnAddPicture(sender: UIButton) {

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            //var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func selectPicture(sender: UIButton) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            //var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = false
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func btnSave(sender: UIButton) {

        var imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)
        var compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alert = UIAlertView(title: "Wow",
                                message: "Your image has been saved to Photo Library!",
                                delegate: nil,
                                cancelButtonTitle: "Ok")
        alert.show()
        
        print(compressedJPGImage)
        
        //Here we must save the parameter of the picture (location,Date, Time, Etc) + Note: Tittle and Details
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("NotesDetailsVC")
        
        txtTittle.text = localVar
        
        // Check if my device has camera or not
        if !UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            //takePictureButton.hidden = true
            takePictureButton.enabled = false
        }

    }

    

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion:nil)
        imageView.image = image
        
    }



}
