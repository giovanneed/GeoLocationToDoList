//
//  FireBaseAPI.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-21.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit

class FirebaseAPI {
    
    var databaseReference = Database.database().reference(withPath: "Collections")

    
    init(){
        
    }
    
    
    
    func createNewUser(withEmail email:String, password:String, image: UIImage, name: String, callback: @escaping(_ success: Bool,_ progress: Int?, _ error: Error?) -> Void) {
        
        var profileImageURL : URL?
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                callback(false,nil,error)
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error{
                    callback(false,nil,error)
                    return
                }
                
                
                self.uploadImage(image: image) { (success, url, error) in
                    if let error = error{
                        callback(false,nil,error)
                        return
                    }
                    
                    if success, let url = url {
                        profileImageURL = url
                    }
                    
                    if let request = Auth.auth().currentUser?.createProfileChangeRequest(){
                         
                        if let url = profileImageURL{
                            request.photoURL = url
                        }
                        
                        request.displayName = name
                        

                        request.commitChanges(completion: { (error) in
                            if let error = error{
                                callback(false,nil,error)
                                return
                            }
                            
                            callback(true,nil,nil)
                                         
                        })
                    }
                    
                }
            }
            
            //callback?(nil)
        }
        
    }
    
    func login(withEmail email:String, password: String, callback: @escaping(_ success: Bool,_ error: Error?)->Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error{
                callback(false,error)
                return
            }
            
            callback(true,nil)

        }
        
    }
    
    func getUserName(callback: @escaping(_ success: Bool,_ name: String?, _ error: Error?)->Void) {
        
        
        if let name = Auth.auth().currentUser?.displayName  {
            callback(true,name,nil)
            return
        }
        
    }
    
    func getUserProfileImageURL(callback: @escaping(_ success: Bool,_ imageURL: URL?, _ error: Error?)->Void) {

        if let imageURL = Auth.auth().currentUser?.photoURL {
            callback(true,imageURL,nil)
        }
       
        
    }
    
    
    func createNewCollection(withCollection jsonObject:[String: Any], title: String , callback: @escaping(_ success: Bool,_ error: Error?)->Void ) {
        
        let objectRef = databaseReference.child(title)
        
        objectRef.setValue(jsonObject)
        
        callback(true,nil)

        
    }
    
    
    func createNewTask(withTask jsonObject:[String: Any], collectionTitle: String , taskTitle: String, callback: @escaping(_ success: Bool,_ error: Error?)->Void ) {
           
        let objectRef = databaseReference.child(collectionTitle).child("tasks").child(taskTitle)
           
           objectRef.setValue(jsonObject)
           
           callback(true,nil)
        return

           
    }
    
    func setTaskDone(withTask jsonObject:[String: Any], collectionTitle: String , taskTitle: String, callback: @escaping(_ success: Bool,_ error: Error?)->Void ) {
              
           let objectRef = databaseReference.child(collectionTitle).child("tasks").child(taskTitle)
              
              objectRef.setValue(jsonObject)
              
              callback(true,nil)

              
       }
    
    
    func deleteCollection(collectionTitle: String,callback: @escaping(_ success: Bool,_ error: Error?)->Void){
           
        let objectRef = databaseReference.child(collectionTitle)
            
        objectRef.removeValue() {error, _ in
            
            if error == nil  {
                callback(true,nil)
                return
            }
            
            callback(false, error)
            return
            
        }
                       
               
    }
    
  
    func deleteTaskFromCollection(collectionTitle: String, taskTitle: String, callback: @escaping(_ success: Bool,_ error: Error?)->Void){
           
        let objectRef = databaseReference.child(collectionTitle).child("tasks").child(taskTitle)
            
        objectRef.removeValue() {error, _ in
            
            if error == nil  {
                callback(true,nil)
                return
            }
            
            callback(false, error)
            return
            
        }
                       
               
    }
    
    func searchCollection(by title: String, callback: @escaping(_ success: Bool,_ collection : [String:AnyObject]?, _ error: Error?)->Void) {
        
        databaseReference.observe(DataEventType.value) { (snapshot) in
            if let collections = snapshot.value as? [String : AnyObject] {
                var founded : [String:AnyObject]?
                for collection in collections {
                    if collection.key == title, let collectionJSON = collection.value as?  [String:AnyObject] {
                    
                        founded = collectionJSON
                        
                    }
                }
                
                callback(true, founded, nil)

                               
            }
        }
    
        
    }
    
    func getAllCollections(callback: @escaping(_ success: Bool,_ collections: [String: Any]?,_ error: Error?)->Void ){
        
        databaseReference.observe(DataEventType.value) { (snapshot) in
            if let collections = snapshot.value as? [String : AnyObject] {
                        
               callback(true, collections, nil)
            }
        }
        
    }
    
    func logout( callback: @escaping(_ success: Bool)-> Void) {
        
        do {
            try Auth.auth().signOut()
            callback(true)
        } catch let error {
            print(error)
        }
        
    }
    
    func saveData(ref: DatabaseReference, child: String, object: [String: Any], callback: @escaping(_ success: Bool) -> Void){
        
        let objectRef = ref.child(child)

        objectRef.setValue(object)
        
        callback(true)

    }
    
    
    func getLoggedUserInformation()->User{
        
        let loggedUser = User()
        
        if let name = Auth.auth().currentUser?.displayName  {
            loggedUser.name = name
        }
                  
        if let imageURL = Auth.auth().currentUser?.photoURL {
            loggedUser.profileImageURL = imageURL
        }
    
        return loggedUser

    }
    
    func saveUserInfo(name: String, url: URL, callback: @escaping(_ success: Bool, _ error: Error?) -> Void){
            
        createProfileChangeRequest(photoUrl: url, name: name) { (error) in
             if let error = error {
                callback(false,error)
            } else {
                callback(true, nil)
            }
        }
        
    }
    
    func createProfileChangeRequest(photoUrl: URL? = nil, name: String? = nil, _ callback: ((Error?) -> ())? = nil){
              if let request = Auth.auth().currentUser?.createProfileChangeRequest(){
                  if let name = name{
                      request.displayName = name
                  }
                  if let url = photoUrl{
                      request.photoURL = url
                  }

                  request.commitChanges(completion: { (error) in
                      callback?(error)
                  })
              }
    }
    
    func uploadImage(image: UIImage,callback: @escaping(_ success: Bool,_ URL : URL?,_ error: Error?) -> Void){
        
        guard let id =  Auth.auth().currentUser?.uid else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        
        let profileImgReference = Storage.storage().reference().child("profile_image_urls").child("\(id).png")
        let uploadTask = profileImgReference.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
               
                profileImgReference.downloadURL { url, error in
                    if let error = error {
                        callback(false, nil, error)
                    } else {
                        if let url = url {
                            callback(true, url, nil)
                        }
                    }
                }
            }
        }
        uploadTask.observe(.progress, handler: { (snapshot) in
            print(snapshot.progress?.fractionCompleted ?? "")
            // Here you can get the progress of the upload process.
        })
    }
    
    func reloadUser(_ callback: ((Error?) -> ())? = nil){
           Auth.auth().currentUser?.reload(completion: { (error) in
               callback?(error)
           })
    }
    
    
    func deleteDataFromDatabase(ref: DatabaseReference, id: String, callback: @escaping(_ error: Error?) -> Void){
        
          
              let reference = ref.child(id)
              reference.removeValue { error, _ in
                
                callback(error)
              }
    }
    
    func retriveDataFromDataBase(ref: DatabaseReference, callback: @escaping(_ people: [Person], _ error: Error?) -> Void  ){

            var people : [Person] = []

            ref.observe(DataEventType.value) { (snapshot) in
                print(snapshot)
               let peopleDict = snapshot.value as? [String : AnyObject] ?? [:]
                for personDict in peopleDict {
                    
                    let id = personDict.key
                    if let personObject = personDict.value as? [String: AnyObject] {
                        print(personObject)
                        let person = Person(json:personObject, id: id)
                        
                        people.append(person)

                    }
                }
                
                callback(people, nil)
                
            }
            
            
            /* ref.observeSingleEvent(of: .childAdded) { (snapshot) in
                print(snapshot)
            }
            ref.child("people").observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
             print(snapshot)


              // ...
              }) { (error) in
                print(error.localizedDescription)
            }*/
    //
    //        refHandle = postRef.observe(DataEventType.value, with: { (snapshot) in
    //          let postDict = snapshot.value as? [String : AnyObject] ?? [:]
    //          // ...
    //        })
               
            /*
             ref.observeSingleEvent(of: .childAdded, with: { (snapshot) in
                 if let person = snapshot.value as? [String:Any] {
                                 //Do not cast print it directly may be score is Int not string
                                 print(person)
                 }
             }
             */
                   
        }
       
    
}
