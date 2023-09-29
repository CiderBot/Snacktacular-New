//
//  LocationManager.swift
//  PlaceLookupDemo
//
//  Created by Steven Yung on 9/28/23.
//

import Foundation
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion()
    
    private let locationManager = CLLocationManager()
    
    override init () {  // overrides existing initializer
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLHeadingFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation() // remember to update the Info.plist
        locationManager.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)    // 5000 meters is about 3 miles
    }
    
}
