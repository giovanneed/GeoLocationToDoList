//
//  RegisterViewController.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-26.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController : UIViewController {
    @IBOutlet weak var nameTextFild: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    let firebaseAPI = FirebaseAPI()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.customizeLayout()
    }
    
    func customizeLayout(){
        self.profileImageView.setRounded()

        
        registerButton.setBorder(border: 1)
        registerButton.setBorderRounded(radius: 5)
        addImageButton.setBorder(border: 1)
        addImageButton.setBorderRounded(radius: 5)
        
        if traitCollection.userInterfaceStyle == .dark {
            addImageButton.setTitleColor(.white, for: .normal)
            registerButton.setTitleColor(.white, for: .normal)

        }
        
    
    }
    @IBAction func addImageProfile(_ sender: Any) {
        
        pickImageFromGallery(imagePicker: self.imagePicker)

    }
    
    @IBAction func register(_ sender: Any) {
        
        self.loading(show: true)
        if formDataPersist() {
            
            guard let email = emailTextField.text,
                let password = passwordTextField.text,
                let profile = profileImageView.image,
                let name = nameTextFild.text else {
                    self.showMessage(title: "Error", message: "All fields are required!")

                    self.loading(show: false)
                    return

            }
            
            firebaseAPI.createNewUser(withEmail: email, password: password, image: profile, name: name) { (success, progress, error) in
                
                if success == false, let error = error {
                    self.showMessage(withError: error)
        
                    self.loading(show: false)
                    return
                }
                
                if success {
                    self.showMessage(title: "Success", message: "User was created!")
                    self.loading(show: false)
                    return

                }
                
            }
            
        }
    }
    
}


extension RegisterViewController {
    
    func formDataPersist() -> Bool {
        
        if emailTextField.text == "", passwordTextField.text == "", confirmTextField.text == "", nameTextFild.text == ""  {
            return false
        }
        
        if passwordTextField.text != confirmTextField.text {
            return false
        }
        
        return true
    }
}


extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           picker.dismiss(animated: true, completion: nil)
           let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                    profileImageView.image = image

    }
}
