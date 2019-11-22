//
//  ViewController.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-20.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var registerName: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    
    @IBOutlet weak var loginEmail: UITextField!
    
    @IBOutlet weak var loginPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginEmail.text = "123456@test.com"
        self.loginPassword.text = "123456"
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        
        guard let userEmail = loginEmail.text else { return }
        guard let userPassword = loginPassword.text else { return }
        
        login(withEmail: userEmail, password: userPassword) { (error) in
            
            if let error = error {
                self.showMessage(title: "Error", message: error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "LoggedSegue", sender: nil)
            }
            
        }
    }
    @IBAction func register(_ sender: Any) {
        
        guard let userEmail = registerEmail.text else { return }
        guard let userPassword = registerPassword.text else { return }
        
        
        createUser(email: userEmail, password: userPassword) { (error) in
            if let error = error {
                self.showMessage(title: "Error", message: error.localizedDescription)
            } else {
                self.showMessage(title: "Succes", message: "User " + userEmail + " was created successfully.")

            }
        }
    }
    
    
    func createUser(email: String, password: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
              if let e = error{
                  print(e)
                  callback?(e)
                  return
              }
              callback?(nil)
          }
    }
    
    
    func login(withEmail email: String, password: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let e = error{
                callback?(e)
                print(e)

                return
            }
            callback?(nil)
        }
    }
    
    
    


}

