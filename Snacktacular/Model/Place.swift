//
//  Place.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/29/23.
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
        
        cityAndState = placemark.locality ?? "" // this should be city
        if let state = placemark.administrativeArea { // this should be state
            // if state is empty, cityAndState stays the same, otherwise:
            // show either state or city, state depending which fields are not empty
            cityAndState = cityAndState.isEmpty ? state : "\(cityAndState), \(state)"
        }
        
        address = placemark.subThoroughfare ?? ""   // in the US, this is usually the street number
        if let street = placemark.thoroughfare {    // in the US, this is usually the street name
            // filling in the street address similar to city state info
            address = address.isEmpty ? street : "\(address) \(street)"
        }
        
        // now combine everything together, also trim any characters in the current address field
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty {
            // no address, then just city and state info
            address = cityAndState
        } else {
            address = cityAndState.isEmpty ? address : "\(address), \(cityAndState)"
        }
        
        return address
    }
    
    var latitude: CLLocationDegrees {   // this is really a Double
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {   // this is really a Double
        self.mapItem.placemark.coordinate.longitude
    }
}
