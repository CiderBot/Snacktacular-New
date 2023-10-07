//
//  LocationManager.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/29/23.
//

import Foundation
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion()
    
    let regionSize = 5000.0
    // setting some default in case we can not get the location
    let appleHQLoc = CLLocation(latitude: 37.3359404078055, longitude: -122.0083711891967).coordinate
    let appleHQReg = MKCoordinateRegion(center: CLLocation(latitude: 37.3359404078055, longitude: -122.0083711891967).coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
    }
}
