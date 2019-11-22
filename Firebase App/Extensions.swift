//
//  Extensions.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-21.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func loading(show: Bool){
        if show {
            let loading = UIActivityIndicatorView()
            loading.startAnimating()
            
            let view = UIView(frame: self.view.frame)
                   view.backgroundColor = .black
                   view.alpha = 0.4
                   view.tag = 182
                   view.addSubview(loading)
                   
                   self.view.addSubview(view)
        }else {
            for view in view.subviews {
                if view.tag == 182 {
                    view.removeFromSuperview()
                }
            }
        }
       
    }
    
    func showMessage(title: String, message: String) {
           
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

           self.present(alert, animated: true) {
               
           }
       }
    
    func getTimestamp()->String{
         let timestamp = Int64(Date().timeIntervalSince1970 * 1000)

         return String(timestamp)

     }
    
    func pickImageFromGallery(imagePicker: UIImagePickerController){
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

                                    imagePicker.sourceType = .savedPhotosAlbum
                                    imagePicker.allowsEditing = false

                                    present(imagePicker, animated: true, completion: nil)
                         }
        
    }
    
    
   
    
    
    
    func downloadImage(from url: URL, imageView: UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
           URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
       
    
    
    
}
