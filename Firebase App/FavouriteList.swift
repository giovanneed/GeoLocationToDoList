//
//  FavouriteList.swift
//  Firebase App
//
//  Created by gio emiliano on 2019-11-27.
//  Copyright © 2019 Giovanne Emiliano. All rights reserved.
//

import Foundation
import UIKit

class FavouriteList {

    private static var _instance: FavouriteList = {
        let favouriteList = FavouriteList()


        return favouriteList
    }()

    
    private(set) var favorites : [String]

    
    func hello(value: String) {
        print("hello " + value)
    }

    private init() {
        
        let defaults = UserDefaults.standard
        let storeFavourites = defaults.object(forKey: "favourites") as? [String]
        if let storeFavourites = storeFavourites {
            self.favorites = storeFavourites
        } else {
            self.favorites = []
        }
        
        
    }
    
    func addFavourite(fontName: String) {
        if (!favorites.contains(fontName)) {
            favorites.append(fontName)
        }
    }
    
    func removeFavourite(fontName: String) {
        if let index = favorites.firstIndex(of: fontName) {
            favorites.remove(at: index)
        }
    }

    
    func saveFavourite() {
        let defaults = UserDefaults.standard
        defaults.set(favorites, forKey: "favourites")
        defaults.synchronize()
    }


    class func getInstance() -> FavouriteList {
        return _instance
    }

}


class test: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var f = FavouriteList.getInstance()
        f.hello(value: "hi")
    }
    
}
