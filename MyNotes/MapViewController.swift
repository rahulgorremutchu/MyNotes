//
//  MapViewController.swift
//  MyNotes
//
//  Created by Mahin on 13/04/18.
//  Copyright © 2018 Quickeans. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapViewNoteLocation: MKMapView!
    
    var latitude = Double()
    var longitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapViewNoteLocation.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapViewNoteLocation.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
