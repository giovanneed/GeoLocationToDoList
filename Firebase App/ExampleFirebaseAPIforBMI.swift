//
//  ExampleFirebaseAPIforBMI.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-12-14.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
import UIKit

class ExampleFirebaseAPIforBMI : UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userAgeTextField: UITextField!
    
    @IBOutlet weak var userGenderTextField: UITextField!
    
    @IBOutlet weak var heightSlider: UISlider!
    
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var heightTextLabel: UILabel!
    
    @IBOutlet weak var weightTextLabel: UILabel!
    
    @IBOutlet weak var BMIResultTextLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var allResultsSavedOnFirebase : [BMIResult] = []
    
    var weight:Double = 0.0
    
    var height:Double = 0.0

    var BMI:Double = 0.0

    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        loadResultsFromFirebase()
        loadUserInfoFromFirebase()
    }
    
    func loadUserInfoFromFirebase(){
        
        FirebaseAPIforBMI().getUser { (name,age, gender, weight, height) in
            
            self.userNameTextField.text = name
             
            self.userAgeTextField.text = age
             
            self.userGenderTextField.text = gender
            
            self.weight = weight
            
            self.height = height
            
            self.weightSlider.value = Float(weight)
            
            self.heightSlider.value = Float(height)
            
            self.weightTextLabel.text = weight.toString() + " Kg"
            
            self.heightTextLabel.text = height.toString() + " cm"
            
            print(weight.toString())
            print(height.toString())

            
        }
    }
    
    func loadResultsFromFirebase(){
        
        allResultsSavedOnFirebase = []
        
        FirebaseAPIforBMI().getAllBMIResults(callback: { (allResultsFoundOnFirebase) in
            self.allResultsSavedOnFirebase = allResultsFoundOnFirebase
                self.tableView.reloadData()
        })
    }
    
    @IBAction func saveUserInfoButtonAction(_ sender: Any) {
        
        guard let name = self.userNameTextField.text else { return }
        guard let age = self.userAgeTextField.text else { return }
        guard let gender = self.userGenderTextField.text else { return }
        
        
        FirebaseAPIforBMI().saveUser(withName: name, age: age, gender: gender, weight: weight, height: height) { (success, error) in
            
        }
     
        
    }
    
    @IBAction func calculateBMIButtonAction(_ sender: Any) {
        
        let heightCM = height / 100
         BMI = weight / (heightCM * heightCM)
        BMIResultTextLabel.text = "BMI Result: " + BMI.toString()
        
    }
    
    @IBAction func saveBMIResultButtonAction(_ sender: Any) {
        
        if BMI == 0.0 || weight == 0.0 || height == 00 {
            return
        }
        
        FirebaseAPIforBMI().saveNewBMIReport(with: weight, height: height, BMI: BMI) { (success, error) in
            self.loadResultsFromFirebase()
        }
        
    }
    @IBAction func deleteAllSavedResultsButtonAction(_ sender: Any) {
        
        FirebaseAPIforBMI().deleteAllResults { (success, error) in
            self.allResultsSavedOnFirebase.removeAll()
            self.tableView.reloadData()
            self.loadResultsFromFirebase()
        }
    }
    
    @IBAction func heightSilderHasChangedAction(_ sender: Any) {
        
        height = Double(heightSlider.value)
        self.heightTextLabel.text = height.toString() + " cm"
        
   
              
    }
    
    @IBAction func weightSilderHasChangedAction(_ sender: Any) {
        
       weight = Double(weightSlider.value)
        self.weightTextLabel.text = weight.toString() + " Kg"


    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allResultsSavedOnFirebase.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "CellBMI", for: indexPath)

         let resultBMI = allResultsSavedOnFirebase[indexPath.row]
        
        let resultDescription = "Weight: " + resultBMI.weight.toString() + " Height: " + resultBMI.height.toString() + " BMI: " + resultBMI.BMI.toString()
        
        
        cell.textLabel?.text = resultDescription
               
        return cell
          
        
      }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if (editingStyle == .delete) {
               
               let resultBMI = allResultsSavedOnFirebase[indexPath.row]

            FirebaseAPIforBMI().deleteResult(BMIRecordID: resultBMI.id) { (success, error) in
                self.loadResultsFromFirebase()
            }
            
            allResultsSavedOnFirebase.remove(at: indexPath.row)

         }
    }
      
    
}
