//
//  Note.swift
//  notesApp
//
//  Created by user121091 on 7/31/16.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit

struct Note {
    var title: String
    var date: String
    var geolocation: String
    var image: String
    var message: String
    
    init() {
        self.title = ""
        self.date = ""
        self.geolocation = ""
        self.image = ""
        self.message  = ""
    }
    
    init(title: String, date: String, geolocation: String, image: String, message: String) {
        self.title = title
        self.date = date
        self.geolocation = geolocation
        self.image = image
        self.message  = message
    }
    
    
}


