//
//  Annotation.swift
//  CBA_TestApp
//
//  Created by Kiran Gurung on 31/10/17.
//  Copyright © 2017 Kiran Gurung. All rights reserved.
//

import Foundation
import MapKit
class Annotation: NSObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
