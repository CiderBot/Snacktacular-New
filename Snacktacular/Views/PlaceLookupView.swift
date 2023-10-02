//
//  PlaceLookupView.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/29/23.
//

import SwiftUI
import MapKit

struct PlaceLookupView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placeVM = PlaceViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    @Binding var returnedSpot : Spot
    
    var body: some View {
        NavigationStack {
            List(placeVM.placesList) { place in
                VStack (alignment: .leading) {
                    Text(place.name)
                        .font(.title)
                    Text(place.address)
                        .font(.title2)
                }
                .onTapGesture {
                    returnedSpot.name = place.name
                    returnedSpot.address = place.address
                    returnedSpot.latitude = place.latitude
                    returnedSpot.longitude = place.longitude
                    dismiss()
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText) {
                if !searchText.isEmpty {
                    placeVM.search(searchText: searchText, region: locationManager.region)
                } else {
                    placeVM.placesList = []
                }
            }
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
    PlaceLookupView(returnedSpot: .constant(Spot()))
        .environmentObject(LocationManager())
}
