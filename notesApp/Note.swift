//
//  Note.swift
//  notesApp
//
//  Created by user121091 on 7/31/16.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit

class Note : NSObject, NSCoding, NSCopying{
    private static let notesKey = "notesKey"
    var id: Int = 0
    var title: String = ""
    var date: String = ""
    var geolocation: String = ""
    var image: UIImage?
    var message: String = ""
    var notesList = [Note]()
   
    override init() {
    }
    
    init(id:Int, title:String, date:String, geolocation:String, image:UIImage?, message:String) {
        self.id = id
        self.title = title
        self.date = date
        self.geolocation = geolocation
        self.image = image
        self.message = message
    }
    
    required init(coder decoder: NSCoder) {
        id = decoder.decodeIntegerForKey("idKey")
        title = decoder.decodeObjectForKey("titleKey") as! String
        date = decoder.decodeObjectForKey("dateKey") as! String
        geolocation = decoder.decodeObjectForKey("geolocationKey") as! String
        image = decoder.decodeObjectForKey("imageKey") as? UIImage
        message = decoder.decodeObjectForKey("messageKey") as! String
        
        notesList = (decoder.decodeObjectForKey(Note.notesKey) as? [Note])!
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeInt(32, forKey: "idKey")
        coder.encodeObject(title, forKey: "titleKey")
        coder.encodeObject(date, forKey: "dateKey")
        coder.encodeObject(geolocation, forKey: "geolocationKey")
        coder.encodeObject(image, forKey: "imageKey")
        coder.encodeObject(message, forKey: "messageKey")
        coder.encodeObject(notesList, forKey: Note.notesKey)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Note()
        var newNote = Array<Note>()
        for note in notesList {
            newNote.append(note)
        }
        copy.notesList = newNote
        return copy
    }
    
}


