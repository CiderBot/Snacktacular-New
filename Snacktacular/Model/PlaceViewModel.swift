//
//  PlaceViewModel.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/29/23.
//

import Foundation
import MapKit

@MainActor
class PlaceViewModel: ObservableObject {
    @Published var placesList: [Place] = []
    
    func search(searchText: String, region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("😡 ERROR: \(error?.localizedDescription ?? "Unknown Location Search Error")")
                return
            }
            
            // this will load the search results into placesList
            self.placesList = response.mapItems.map(Place.init) // calls Place init() to create the struct
        }
    }
}
