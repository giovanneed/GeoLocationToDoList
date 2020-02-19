//
//  TasksViewContoller.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-27.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class TasksViewController : UIViewController {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var collectionTitleLabel: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var newTaskTextField: UITextField!
    @IBOutlet weak var addNewTaskButton: UIButton!
    
    @IBOutlet weak var tasksTitleLabel: UILabel!
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    var collection = Collection()
    
    let firebaseAPI = FirebaseAPI()
    
    var flagUpdate = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCollectionInfo()
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        
        loadTasks()
        self.customizeLayout()
        
    }
    
    func customizeLayout(){
          
        self.viewBackground.setBorderRounded(radius: 10)
          
          self.view.backgroundColor = Colors().backgroundView
          self.viewBackground.backgroundColor = Colors().backgroundViewOverlay
          self.addNewTaskButton.setBorderRounded(radius: 25)
          self.addNewTaskButton.backgroundColor = Colors().backgroundButton
        
        if traitCollection.userInterfaceStyle == .dark {
                   self.viewBackground.backgroundColor = .black
                   self.view.backgroundColor = Colors().backgroundGray
        }
        
  
    }
    
    
    @IBAction func addNewTask(_ sender: Any) {
        self.view.endEditing(true)

        guard let taskText = newTaskTextField.text else {
            return
        }
        
        let newTask = Task(text: taskText, done: false, timestamp: getTimestamp())
        
        newTaskTextField.text = ""
        
        firebaseAPI.createNewTask(withTask: newTask.toAnyObject(), collectionTitle: collection.title, taskTitle: newTask.text) { (success, error) in
            
            if success {
                self.loadTasks()
            }
            
            
        }
        
        
    }
    
    func loadTasks(){
        self.flagUpdate = true

        firebaseAPI.searchCollection(by: collection.title) { (success, collectionJSON, error) in
            if success, let collectionJSON = collectionJSON  {
                
                self.collection = Collection(json: collectionJSON)
                if self.flagUpdate  {
                    DispatchQueue.main.async {
                       self.tasksTableView.reloadData()
                    }
                    self.flagUpdate = false
                }

            }
        }
    }
    
    
}


extension TasksViewController {
    
    func loadCollectionInfo(){
        collectionTitleLabel.text = collection.title
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta: 0.2)
        let centre = CLLocationCoordinate2D(latitude: collection.latitude, longitude: collection.longitude)
        let region = MKCoordinateRegion(center: centre, span: span)
        map.setRegion(region, animated: true)
              
        let annotation = MKPointAnnotation()
        annotation.coordinate = centre
        map.addAnnotation(annotation)
        
    }
}

extension TasksViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  collection.tasks.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = collection.tasks[indexPath.row]

        if task.done == true {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellDone") as! TaskCellDone
            
            cell.setTask(task: task)
            
            cell.delegate = self
            
                           
             return cell
        }
        
      
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
         
       
         
       
        cell.setTask(task: task)
        
        cell.delegate = self
        
                       
         return cell
     }
    
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 80
     }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let task = collection.tasks[indexPath.row]

            deleteTask(task)
            
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
}

extension TasksViewController : TaskCellDelegate {
    func deleteTask(_ task: Task) {
        
        firebaseAPI.deleteTaskFromCollection(collectionTitle: collection.title, taskTitle: task.text) { (success, error) in
            if success {
                self.loadTasks()

            }
        }
        
    }
    
    
    func setTaskDone(_ task: Task) {
        
        task.done = true
        
        firebaseAPI.setTaskDone(withTask: task.toAnyObject(), collectionTitle: self.collection.title, taskTitle: task.text) { (success, error) in
              if success {
                          self.loadTasks()

              }
        }
        
    }
    
    
}



protocol TaskCellDelegate: class {
    func deleteTask(_ task: Task)
    func setTaskDone(_ task: Task)

    
}


class TaskCell: UITableViewCell {
    
    
    @IBOutlet weak var titleTextLabel: UILabel!

    var delegate: TaskCellDelegate?

    var task = Task()
    func setTask(task: Task) {
        self.task = task
        titleTextLabel.text = task.text
        
        self.titleTextLabel.textColor = .black
        
        if traitCollection.userInterfaceStyle == .dark {
                self.titleTextLabel.textColor = .white
        }
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(TaskCell.swipeFunction))
             
        self.contentView.addGestureRecognizer(swipe)
            
        
    }
    
   
    
    @objc
    func swipeFunction(gesture:UISwipeGestureRecognizer) {
        
        if (gesture.direction == .right) {
            //titleTextLabel.strikeThrough()
            delegate?.setTaskDone(self.task)

        }
    }
   
    
    @IBAction func deleteTask(_ sender: Any) {
        delegate?.deleteTask(self.task)
    }
    
}


class TaskCellDone: UITableViewCell {
    
    
    @IBOutlet weak var titleTextLabel: UILabel!

    var delegate: TaskCellDelegate?

    var task = Task()
    func setTask(task: Task) {
        self.task = task
        titleTextLabel.text = task.text
        titleTextLabel.strikeThrough()
        
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(TaskCell.swipeFunction))
             
        self.contentView.addGestureRecognizer(swipe)
            
        
    }
    
    @objc
    func swipeFunction(gesture:UISwipeGestureRecognizer) {
        
        if (gesture.direction == .right) {
            //titleTextLabel.strikeThrough()
            delegate?.setTaskDone(self.task)

        }
    }
   
    

    
}

