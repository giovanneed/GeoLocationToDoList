//
//  Task.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-27.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
class Task {
    var text: String = ""
    var done: Bool = false
    var timestamp: String = ""
    
    init(){
        
    }
    
    init(text: String, done: Bool, timestamp: String ) {
        self.text = text
        self.done = done
        self.timestamp = timestamp


    }
    
   init(json: [String: AnyObject]) {
        if let text = json["text"] as? String {
            self.text = text
        }
    
        if let done = json["done"] as? Bool {
               self.done = done
        }
    
        if let timestamp = json["timestamp"] as? String {
                 self.timestamp = timestamp
          }
    }
    
    func toAnyObject()-> [String: Any]{
        let jsonObject: [String: Any]  =
            [
                 "text": text,
                 "done" : done,
                 "timestamp" : timestamp
            ]
        
        return jsonObject
        
    }
    
    func description()->String{
        var sDone = " is Not Done"
        if self.done {
            sDone = " is Done!"
        }
        
        return "Task: " + text + " timestamp: " + timestamp + sDone
        
    }
}
