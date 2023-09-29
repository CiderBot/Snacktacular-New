//
//  Place.swift
//  PlaceLookupDemo
//
//  Created by Steven Yung on 9/28/23.
//

import Foundation
import MapKit

struct Place: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name: String {
        self.mapItem.name ?? ""
    }
    
    var address: String {
        let placemark = self.mapItem.placemark
        var cityAndState = ""
        var address = ""
        
        cityAndState = placemark.locality ?? ""
        if let state = placemark.administrativeArea {
            // show either state or city, state
            cityAndState = cityAndState.isEmpty ? state : "\(cityAndState), \(state)"
        }
        
        address = placemark.subThoroughfare ?? ""   // in US, this is usually the street number
        if let street = placemark.thoroughfare {    // in US, this is usually the street name
            address = address.isEmpty ? street : "\(address) \(street)"
        }
        
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty {
            // no address, then just cityAndState
            address = cityAndState
        } else {
            address = cityAndState.isEmpty ? address : "\(address), \(cityAndState)"
        }
        
        return address
    }
    
    var latitude: CLLocationDegrees { // this is really a Double
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: CLLocationDegrees { // this is really a Double
        self.mapItem.placemark.coordinate.longitude
    }
}
