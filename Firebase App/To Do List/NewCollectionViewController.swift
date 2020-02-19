//
//  NewCollectionViewController.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-26.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation



class NewCollectionViewController : UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var loactionTitleLabel: UILabel!
    
    @IBOutlet weak var newCollectionButton: UIButton!
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0

    let firebaseAPI = FirebaseAPI()

    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        map.delegate = self
        
        customizeLayout()
        
    }
    
    func customizeLayout(){
           newCollectionButton.setBorder(border: 1)
           newCollectionButton.setBorderRounded(radius: 5)
        
        if traitCollection.userInterfaceStyle == .dark {
                 newCollectionButton.setTitleColor(.white, for: .normal)

        }
             
    }
       
    
    @IBAction func newCollection(_ sender: Any) {
        
        guard let title = titleTextField.text else {
            self.showMessage(title: "Error", message: "All fields are required!")
            return

        }
        
        let collection = Collection(title: title, latitude: latitude, longitude: longitude, timestamp: self.getTimestamp())
        
       

        firebaseAPI.createNewCollection(withCollection: collection.toAnyObject(), title: title) { (success, error) in
            self.dismiss(animated: true, completion: nil)

        }
        
        
        
    }
    
}


extension NewCollectionViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            manager.startUpdatingLocation()

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(location.latitude) \(location.longitude)")
        
        
        self.latitude = location.latitude
        self.longitude = location.longitude
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta: 0.2)
        let centre = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: centre, span: span)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = centre
        map.addAnnotation(annotation)


    }
}



extension NewCollectionViewController: MKMapViewDelegate {
  // 1
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // 2
    //guard let annotation = annotation as? Artwork else { return nil }
    // 3
    let identifier = "marker"
    var view: MKMarkerAnnotationView
    // 4
    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
      as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      // 5
      view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
}
