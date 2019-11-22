//
//  User.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-21.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
import UIKit


class User {
    
    var name : String = ""
    var profileImageURL : URL?
    
    var profile = UIImage()
    
    init(){
        
    }
    
    init(name: String, profile: UIImage) {
        self.name = name
        self.profile = profile
    }
    
    func greetings()->String {
        return "Welcome, " + name
    }
}
