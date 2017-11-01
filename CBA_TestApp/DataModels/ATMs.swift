//
//  ATMs.swift
//  CBA_TestApp
//
//  Created by Kiran Gurung on 31/10/17.
//  Copyright © 2017 Kiran Gurung. All rights reserved.
//

import Foundation

class ATMLocation {
    
    var id: String
    var name: String
    var address: String
    var latitude: Float
    var longitutude: Float
    
    var description:String {
        return "{\(id), \(name)}"
    }
    
    init(id: String, name: String, address: String, latitude: Float, longitutude: Float) {
        self.id = id
        self.name = name
        self.address = address.replacingOccurrences(of: "<br/>", with: "\n")
        self.latitude = latitude
        self.longitutude = longitutude
    }
    
    convenience init () {
        self.init(id: "", name: "", address: "", latitude: 0.0, longitutude: 0.0)
    }
    
}
