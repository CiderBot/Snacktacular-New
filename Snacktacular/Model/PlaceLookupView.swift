//
//  PlaceLookupView.swift
//  PlaceLookupDemo
//
//  Created by Steven Yung on 9/28/23.
//

import SwiftUI
import MapKit

struct PlaceLookupView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placeVM = PlaceViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    @Binding var returnedPlace: Place
    
    var body: some View {
        NavigationStack {
            List(placeVM.places) {place in
                VStack (alignment: .leading) {
                    Text(place.name)
                        .font(.title2)
                    Text(place.address)
                        .font(.callout)
                }
                .onTapGesture {
                    returnedPlace = place
                    dismiss()
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText, {
                if !searchText.isEmpty {
                    //note: can add to search text
                    // let newSearchText = "restaurant" + searchText
                    placeVM.search(text: searchText, region: locationManager.region)
                } else {
                    placeVM.places = []
                }
            })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PlaceLookupView(returnedPlace: .constant(Place(mapItem: MKMapItem())))
        .environmentObject(LocationManager())
}
