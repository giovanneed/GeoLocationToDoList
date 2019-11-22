//
//  Person.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-21.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation


class Person {
    var name: String = ""
    var id: String = ""

    var age: Int = 0
    
    init(){
        
    }
    init(name: String, age: String) {
        self.name = name;
        if let age = Int(age) {
            self.age = age
        } else {
            self.age = 0
        }
        

    }
    
    init(json: [String: AnyObject], id: String ) {
        if let name = json["name"] as? String {
            self.name = name
        }
        
        if let age = json["age"] as? Int {
                   self.age = age
        }
        
        self.id = id
    }
    
    func toAnyObject()-> [String: Any]{
        let jsonObject: [String: Any]  =
            [
                 "name": name,
                 "age": age
            ]
        
        return jsonObject
        
    }
}
