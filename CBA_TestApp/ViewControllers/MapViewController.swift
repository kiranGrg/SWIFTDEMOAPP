//
//  MapViewController.swift
//  CBA_TestApp
//
//  Created by Kiran Gurung on 31/10/17.
//  Copyright © 2017 Kiran Gurung. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var atmLocation: ATMLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        renderAnnonationWithCentring()
    }

    private func renderAnnonationWithCentring() -> Void {
        let lat: CLLocationDegrees = Double(atmLocation!.latitude)
        let lng: CLLocationDegrees = Double(atmLocation!.longitutude)
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, lng), MKCoordinateSpanMake(0.005, 0.005))
        mapView.setRegion(region, animated: true)
        let mapAnnotation = Annotation(coordinate: CLLocationCoordinate2DMake(lat, lng), title: atmLocation!.name, subtitle: atmLocation!.address)
        mapView.addAnnotation(mapAnnotation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "CBAFindUsAnnotationIconATM")
        }
        
        return annotationView
    }
}
