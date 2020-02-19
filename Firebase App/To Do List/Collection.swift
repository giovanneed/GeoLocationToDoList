//
//  Collection.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-26.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation

class Collection {
    var title: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var timestamp: String = ""
    var tasks : [Task] = []
    
    init(){
        
    }
    
    init(title: String, latitude: Double, longitude: Double, timestamp: String ) {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp


    }
    
   init(json: [String: AnyObject]) {
    
        print(json)
    
        var tempTasks : [Task] = []
    
        if let title = json["title"] as? String {
            self.title = title
        }
    
        if let latitude = json["latitude"] as? Double {
               self.latitude = latitude
        }
    
        if let longitude = json["longitude"] as? Double {
                 self.longitude = longitude
          }
        if let timestamp = json["timestamp"] as? String {
                self.timestamp = timestamp
        }
        if let tasksJSON = json["tasks"] as? [String: AnyObject] {
            for taskJSON in tasksJSON {
                if let unwrappedTaskJSON = taskJSON.value as? [String: AnyObject] {
                    let task  = Task(json: unwrappedTaskJSON)
                    tempTasks.append(task)
                }
            }
            self.tasks = tempTasks.sorted(by: { $0.text > $1.text })
        }
    }
    
    func toAnyObject()-> [String: Any]{
        let jsonObject: [String: Any]  =
            [
                 "title": title,
                 "latitude" : latitude,
                 "longitude" : longitude,
                 "timestamp" : timestamp,
                 "tasks" : ""
            ]
        
        return jsonObject
        
    }
}
