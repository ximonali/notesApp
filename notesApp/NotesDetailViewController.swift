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
    var note = Note()
    let rootKey = "rootKey"
    var globalIndex: Int = -1;

    
    
    //------ Vars for camera
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var pickMyPicture: UIButton!
    
    @IBOutlet weak var txtLocation: UITextField!
    //@IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtTittle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    
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
        var compressedJPGImage = UIImage?()
        
        if (imageView.image != nil) {
            let imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)
            compressedJPGImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        } else {
            compressedJPGImage = nil
        }


        if (self.globalIndex<0) {
            
            let newNote = Note(id: note.notesList.count, title: txtTittle.text!, date: "07/08/2016", geolocation: "Toronto", image: compressedJPGImage, message: txtDescription.text!)
            note.notesList.append(newNote)
        } else {
            note.notesList[globalIndex].title = txtTittle.text!
            note.notesList[globalIndex].message = txtDescription.text!
            note.notesList[globalIndex].image = imageView.image
        }
        
        let alertController = UIAlertController(title: txtTittle.text, message: "Your note was saved!", preferredStyle: .Alert)
        
        let actionYes = UIAlertAction(title: "Ok", style: .Default) { (action:UIAlertAction) in
            print("---After OK is Pressed---");
            self.updateNote()
            self.navigationController?.popViewControllerAnimated(true)
        }
        
//        let actionNo = UIAlertAction(title: "No", style: .Default) { (action:UIAlertAction) in
//            print("You've pressed No button");
//        }
        
        alertController.addAction(actionYes)
//        alertController.addAction(actionNo)
        self.presentViewController(alertController, animated: true, completion:nil)
        
//Here we must save the parameter of the picture (location,Date, Time, Etc) + Note: Tittle and Details
        
        print("----TITTLE + DESCRIPTION-----")
        print("Tittle: \(txtTittle.text)")
        print("Description: \(txtDescription.text) \n")
        
        print("----IMAGEN-----")
        print(compressedJPGImage)
        print(imageView.image!)
        
        

    }
  
    func dataFileURL() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!.URLByAppendingPathComponent("data.archive")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        name: UIApplicationWillResignActiveNotification, object: app)
       
        //Set Fields for New or Edit Note
        if (globalIndex<0) {
            txtTittle.text = ""
            txtDescription.text = ""
            txtLocation.text = ""
        } else {
            txtTittle.text = note.notesList[globalIndex].title
            txtDescription.text = note.notesList[globalIndex].message
            imageView.image = note.notesList[globalIndex].image
        }
        
        // Check if my device has camera or not
        if !UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            //takePictureButton.hidden = true
            takePictureButton.enabled = false
        }

    }

    func applicationWillResignActive(notification:NSNotification) {
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

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion:nil)
        imageView.image = image
        
    }



}
