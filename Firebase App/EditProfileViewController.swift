//
//  EditProfileViewController.swift
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

class EditProfileViewController : UIViewController {
    
    var user = User()
    
    let firebaseAPI = FirebaseAPI()
    
    var imagePicker = UIImagePickerController()


    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        getUserInfo()

        
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        
        pickImageFromGallery(imagePicker: self.imagePicker)
        
    }
    

    
    @IBAction func updateInfo(_ sender: Any) {
         loading(show: true)
        
        if let image = self.profileImageView.image {
            firebaseAPI.uploadImage(image: image) { (url, error) in
                self.loading(show: false)
                if let error = error {
                    self.showMessage(title: "Error", message: error.localizedDescription)
                } else {
                    if let url = url {
                        self.saveUpdate(url: url)
                        self.showMessage(title: "Success", message: "User info updated!")

                    }
                }
                
            }

        }
    }
    
    func getUserInfo(){
           
        let user = FirebaseAPI().getLoggedUserInformation()
        nameTextField.text = user.name
           
        if let imageURL = user.profileImageURL {
               downloadImage(from: imageURL, imageView: profileImageView)
        }

    }
       
    
    
    
    func saveUpdate(url: URL){
        if let name = nameTextField.text {
            
            firebaseAPI.saveUserInfo(name: name, url: url) { (sucess, error) in
                if let error = error {
                    self.showMessage(title: "Error", message: error.localizedDescription)
                } else {
                    if sucess == true {
                        self.getUserInfo()
                    }
                }
            }
        }
    }
    
    
    
}


extension EditProfileViewController :  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           picker.dismiss(animated: true, completion: nil)
           let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                    profileImageView.image = image

    }
}


