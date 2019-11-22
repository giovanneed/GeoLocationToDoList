//
//  MainViewController.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-20.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MainViewController : UIViewController,  UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    @IBOutlet weak var ageDatabaseTextField: UITextField!
    @IBOutlet weak var nameDatabaseTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var labelWelcome: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    var imagePicker = UIImagePickerController()

    var ref: DatabaseReference!
    
    var people : [Person] = []
    
    var user = User()
    
    let name = Notification.Name("didReceiveData")


    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        ref = Database.database().reference(withPath: "people")
        
        self.navigationItem.setHidesBackButton(true, animated:true);

        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
      
       
    }
    
    @objc func onDidReceiveData(_ notification:Notification) {
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
        loadData()
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
        FirebaseAPI().logout { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
        

        
    }
    func getUserInfo(){
        
        let user = FirebaseAPI().getLoggedUserInformation()
        labelWelcome.text = user.greetings()
        
        if let imageURL = user.profileImageURL {
            downloadImage(from: imageURL, imageView: userImage)
        }

    }
    

    @IBAction func editInfo(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SegueEditInfo", sender: nil)
    }
    

 
    func loadData(){
        
        FirebaseAPI().retriveDataFromDataBase(ref: self.ref) { (people, error) in
            self.people = people
            self.tableView.reloadData()

        }
    }
   
    
    @IBAction func saveToDatabase(_ sender: Any) {
        
        guard let name = nameDatabaseTextField.text, let age = ageDatabaseTextField.text else {return}
        
        if name=="", age=="" {
            return
        }
        
        let person = Person(name: name, age: age)
              
        let timestamp = getTimestamp()
        
        
        
        FirebaseAPI().saveData(ref: self.ref, child: timestamp, object: person.toAnyObject()) { (success) in
            if success == true {
                self.loadData()
                self.nameDatabaseTextField.text = ""
                self.ageDatabaseTextField.text = ""
            }
        }
        

    }
    
       
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell") as! PersonTableViewCell
        
      
        let person = people[indexPath.row]
        
      
        cell.setPerson(person: person)
                      
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
