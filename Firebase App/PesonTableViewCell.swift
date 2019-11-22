//
//  PesonTableViewCell.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-21.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PersonTableViewCell : UITableViewCell {
    
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var person = Person()
    
   
    func setPerson(person: Person) {
        self.person = person
        self.name.text = "Name: " + person.name
        self.age.text =  " Age: " + String(person.age)
              
        
    }
    @IBAction func deleteObject(_ sender: Any) {
        let ref = Database.database().reference(withPath: "people")

        FirebaseAPI().deleteDataFromDatabase(ref: ref, id: person.id) { (error) in
            
            NotificationCenter.default.post(name:NSNotification.Name(rawValue:"reloadData"),
             object: nil)
            
        }
    }
    
}
