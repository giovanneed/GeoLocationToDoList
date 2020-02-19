//
//  HomeViewController.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-26.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class HomeViewController : UIViewController{
    
    let firebaseAPI = FirebaseAPI()

    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var titleCollectionLabel: UILabel!
    
    @IBOutlet weak var listOfCollectionsCollectionView: UICollectionView!
    
    @IBOutlet weak var addNewCollectionButton: UIButton!
    
    
    var collections : [Collection] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfCollectionsCollectionView.delegate = self
        listOfCollectionsCollectionView.dataSource = self
        customizeLayout()
        
    }
    
    func customizeLayout(){
        self.profileImage.setRounded()
        self.viewBackground.setBorderRounded(radius: 10)
        self.listOfCollectionsCollectionView.backgroundView?.backgroundColor = self.view.backgroundColor
        
        self.viewBackground.backgroundColor = .white

        
        self.view.backgroundColor = Colors().backgroundView

        self.addNewCollectionButton.setBorderRounded(radius: 25)
        self.addNewCollectionButton.backgroundColor = Colors().backgroundButton
        
        
        if traitCollection.userInterfaceStyle == .dark {
            self.viewBackground.backgroundColor = .black
            self.view.backgroundColor = Colors().backgroundGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserInfo()
        loadCollectionsFromDatabase()
    }
    
    
    @IBAction func editProfile(_ sender: Any) {
    }
    
    @IBAction func addNewCollection(_ sender: Any) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueTasks" {
            if let collection = sender as? Collection,  let tasksViewController = segue.destination as? TasksViewController{
                
                tasksViewController.collection = collection
            }
        }
    }
    
}

extension HomeViewController {
    
    
    func loadCollectionsFromDatabase(){
        
        
        firebaseAPI.getAllCollections { (success, collections, error) in

            guard let collections = collections, success else {
                return
            }
            
            self.collections = []
             var newCollections : [Collection] = []
            
            for collection in collections {
                if let collectionJSON = collection.value as? [String: AnyObject] {
                    newCollections.append(Collection(json: collectionJSON))
                }
            }
             self.collections = newCollections.sorted {
                $0.title < $1.title
            }
            self.listOfCollectionsCollectionView.reloadData()
 
        }
    }
    func loadUserInfo(){
        
        firebaseAPI.getUserName { (success, name, error) in
            if success, let name = name {
                print(name)
                self.nameLabel.text = name
            }
        }
        
        
        firebaseAPI.getUserProfileImageURL { (success, imageURL, error) in
            if success {
                
                guard let imageURL = imageURL else { return }
                self.downloadImage(from: imageURL, imageView: self.profileImage)

            }
        }
    }
    
    
}


extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collection = self.collections[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.titleTextLabel.text = collection.title
        cell.backgroundLayoutView.setBorderRounded(radius: 10)
        cell.backgroundLayoutView.setBorder(border: 1)
        
        cell.backgroundLayoutView.backgroundColor = Colors().backgroundViewOverlay

        if traitCollection.userInterfaceStyle == .dark {
            cell.backgroundLayoutView.backgroundColor = .black
        }
        
        cell.showMapWith(lat: collection.latitude, lng: collection.longitude)
        
        cell.collection = collection
        
        cell.delegate = self
        
        return cell
    }
    
  
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        
        return CGSize(width: 150, height: 250)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}


extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
        let collection = collections[indexPath.row]
        
        performSegue(withIdentifier: "SegueTasks", sender: collection)
        
    }
    
   
}

extension HomeViewController: CollectionCellDelegate {
    func deleteCollection(_ collection: Collection) {
        firebaseAPI.deleteCollection(collectionTitle: collection.title) { (success, error) in
            if success {
                self.loadCollectionsFromDatabase()

            }
        }
    }
}



class CollectionCell: UICollectionViewCell {
    
    var collection = Collection()
    @IBOutlet weak var titleTextLabel: UILabel!
    
    @IBOutlet weak var backgroundLayoutView: UIView!
    
    var delegate: CollectionCellDelegate?

    @IBOutlet weak var map: MKMapView!
    
    func showMapWith(lat:Double,lng:Double){
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta: 0.2)
        let centre = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: centre, span: span)
        map.setRegion(region, animated: true)
              
        
    }
    
    @IBAction func deleteCollection(_ sender: Any) {
        self.delegate?.deleteCollection(self.collection)
    }
    
}


protocol CollectionCellDelegate: class {
    func deleteCollection(_ collection: Collection)

    
}
