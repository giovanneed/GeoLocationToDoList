//
//  FireBaseAPIforBMI.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-12-13.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit

class FirebaseAPIforBMI {
    
    var databaseReference = Database.database().reference(withPath: "BMIProject")

    
    init(){
        
    }

    
    func getAllBMIResults(callback: @escaping(_ allResultsSaved: [BMIResult])->Void ) {
        
        var allRecordsSaved : [BMIResult] = []
        databaseReference.observe(DataEventType.value) { (snapshot) in
            if let databaseJSON = snapshot.value as? [String : AnyObject] {
                if let recordsJSON = databaseJSON["Results"]  as? [String : AnyObject] {
                    
                    for object in recordsJSON {
                        if let recordJSON = object.value as? [String : AnyObject]{
                            let record = BMIResult(JSON: recordJSON)
                            allRecordsSaved.append(record)
                        }
                    }
                    
                    callback(allRecordsSaved)
                    
                }
            }
        }
    }
    
    func updateBMIReport(BMIResult: BMIResult, callback: @escaping(_ success: Bool,_ error: Error?)->Void ) {
        
 

        let jsonRegisterObject: [String: Any]  =
            [
                "weight": BMIResult.weight,
                "height": BMIResult.height,
                "BMI" : BMIResult.BMI,
        ]
        
              
         let objectRef = databaseReference.child("Results").child(BMIResult.id)
              
         objectRef.setValue(jsonRegisterObject)
              
          callback(true,nil)
          
          return

              
    }
    
    func saveNewBMIReport(with weight: Double , height: Double , BMI: Double, callback: @escaping(_ success: Bool,_ error: Error?)->Void ) {
        
        let timestamp = String(Int64(Date().timeIntervalSince1970 * 1000))


        let jsonRegisterObject: [String: Any]  =
            [
                "weight": weight,
                 "height": height,
                 "BMI" : BMI,
                 "timestamp" : timestamp

            ]
        
              
         let objectRef = databaseReference.child("Results").child(timestamp)
              
         objectRef.setValue(jsonRegisterObject)
              
          callback(true,nil)
          
          return

              
    }
    
    func deleteAllResults(callback: @escaping(_ success: Bool,_ error: Error?)->Void){
        let objectRef = databaseReference.child("Results")
        
        objectRef.removeValue { error, _ in
            callback(true, nil)

        }

    }
    
    func deleteResult(BMIRecordID: String, callback: @escaping(_ success: Bool,_ error: Error?)->Void){
        print(BMIRecordID)
        let objectRef = databaseReference.child("Results").child(BMIRecordID)
        
        objectRef.removeValue { error, _ in
                      
            callback(true, nil)
        }
        
    }
    
    
    func saveUser(withName name: String , age: String , gender: String, weight: Double , height: Double, callback: @escaping(_ success: Bool,_ error: Error?)->Void ) {
        

        let jsonUser: [String: Any]  =
            [
                "name" : name,
                "age": age,
                "gender": gender,
                "weight": weight,
                 "height": height,
            ]
        
              
         let objectRef = databaseReference.child("User")
              
         objectRef.setValue(jsonUser)
              
          callback(true,nil)
          
          return
              
    }
    
    func getUser(callback: @escaping(_ name: String,_ age: String,_ gender: String,_ weight: Double,_ height: Double)->Void) {
        
        databaseReference.observe(DataEventType.value) { (snapshot) in
            if let databaseJSON = snapshot.value as? [String : AnyObject] {
                if let userJSON = databaseJSON["User"]  as? [String : AnyObject] {
                    print(userJSON)
                    var name = ""
                    if let nameWrapped = userJSON["name"] as? String {
                        name = nameWrapped
                    }
                    
                    var age = ""
                    if let ageWrapped = userJSON["age"] as? String {
                        age = ageWrapped
                    }
                    
                    var gender = ""
                    if let genderWrapped = userJSON["gender"] as? String {
                        gender = genderWrapped
                    }
                    
                    var weight = 0.0
                    if let weightWrapped = userJSON["weight"] as? Double {
                        weight = weightWrapped
                    }
                    
                    var height = 0.0
                    if let heightWrapped = userJSON["height"] as? Double {
                        height = heightWrapped
                    }
                    callback(name, age, gender, weight, height)
                    
                    
            }
        }
      }
    }

}

class BMIResult {
    var weight: Double = 0.0
    var height: Double = 0.0
    var BMI: Double = 0.0
    var id: String = ""

    init(){
        
    }
    
    init(JSON: [String:AnyObject]) {
        if let weightWrapped = JSON["weight"] as? Double {
            self.weight = weightWrapped
        }
                           
        if let heightWrapped = JSON["height"] as? Double {
            self.height = heightWrapped
        }
        
        if let BMIWrapped = JSON["BMI"] as? Double {
            self.BMI = BMIWrapped
        }
        if let idWrapped = JSON["timestamp"] as? String {
            self.id = idWrapped
        }
    }
}


extension Double {
    func toString()->String{
        
        return   String(format:"%.2f", self)

        
    }
}
