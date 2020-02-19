//
//  LoginViewController.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-26.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//
//43.785694, -79.227701 centenial

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    let segueSignUpIdentifier = "SegueSignUp"
    let segueSegueSignInIdentifier = "SegueSignIn"

    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    let firebaseAPI = FirebaseAPI()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = "user1@test.com"
        passwordTextField.text = "123456"
        
       /* FirebaseAPIforBMI().saveNewBMIReport(with: 100.0, height: 50.0, BMI: 35.5) { (success, error) in
            
        }
        
        FirebaseAPIforBMI().saveUser(withName: "Giovanne", age: "30", gender: "M", width: 180, height: 180) { (success, error) in
            
        }
        FirebaseAPIforBMI().getUser { (name, age, gender, width, height) in
            print("User : " + name)
        }*/
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeLayout()

    }
    
    func customizeLayout(){
        
        signInButton.setBorder(border: 1)
        signInButton.setBorderRounded(radius: 5)
        signUpButton.setBorder(border: 1)
        signUpButton.setBorderRounded(radius: 5)
        
        
        if traitCollection.userInterfaceStyle == .dark {
            signInButton.setTitleColor(.white, for: .normal)
            signUpButton.setTitleColor(.white, for: .normal)
        } else {
            signInButton.setTitleColor(.black, for: .normal)
            signUpButton.setTitleColor(.black, for: .normal)
        }
        
    
    }
    
    
    
    @IBAction func signIn(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        
        firebaseAPI.login(withEmail: email, password: password) { (success, error) in
            if success == false, let error = error {
                self.showMessage(withError: error)
                return
            }
            
            self.performSegue(withIdentifier: self.segueSegueSignInIdentifier, sender: nil)

        }

        
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        self.performSegue(withIdentifier: segueSignUpIdentifier, sender: nil)
    }
    
}
