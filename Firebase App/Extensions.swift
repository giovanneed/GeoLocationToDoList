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
    
    
    func showMessage(withError error:Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true) {
                      
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


extension UIImageView {
    
   func setRounded() {
        contentMode = .scaleAspectFill
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}

extension UIView {
    
    func setBorderRounded(radius:CGFloat ) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setBorder(border:CGFloat ) {
        self.layer.borderWidth = border
        if traitCollection.userInterfaceStyle == .dark {
            self.layer.borderColor = Colors().borderColorDark
        } else {
            self.layer.borderColor = Colors().borderColorLight
        }
        

    }
    
}

extension UILabel {
    func strikeThrough() {
        guard let string = self.text else { return }
        let stAttributeString =  NSMutableAttributedString(string: string)
        stAttributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,stAttributeString.length))
        self.attributedText = stAttributeString
    }
    
    func normal() {
        let font = UIFont.systemFont(ofSize: 25)

           guard let string = self.text else { return }
           let stAttributeString =  NSMutableAttributedString(string: string)
           stAttributeString.addAttribute(
            NSAttributedString.Key.font,
            value: font,
            range: NSMakeRange(0,stAttributeString.length))
           self.attributedText = stAttributeString
       }
}


extension String {
    func normal() -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 25)

           let attributeString =  NSMutableAttributedString(string: self)
           attributeString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0,attributeString.length))
           return attributeString
       }
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
