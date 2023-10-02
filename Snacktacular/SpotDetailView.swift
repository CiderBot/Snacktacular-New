//
//  SpotDetailView.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/27/23.
//

import SwiftUI
import MapKit

struct SpotDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var spotVM : SpotViewModel
    
    @State var spot: Spot   // return to SpotListView
    @State private var showPlaceLookupSheet = false
    
    // mapping stuff
    @State private var mapRegion = MKCoordinateRegion()
    @State private var cameraMapRegion = MapCameraPosition.region(MKCoordinateRegion())
    let regionSize = 500.0 //meters
    @EnvironmentObject var locationManager: LocationManager
    // location manager is also needed for PlaceLookupView to work in preview mode
    
    var body: some View {
        VStack {
            Group {
                TextField("Name", text: $spot.name)
                    .font(.title)
                TextField("Address", text: $spot.address)
                    .font(.title2)
            }
            .disabled(spot.id != nil)
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(.gray .opacity(0.5), lineWidth: spot.id == nil ? 2.0 : 0.0)
            }
            Map(position: $cameraMapRegion) {
                // bug: new spot does not center, for some reason, the location of the device is not returned
                Marker(spot.name, coordinate: spot.coordinate)
                    .tint(.blue)
            }
            .onChange(of: spot.address) {
                mapRegion = MKCoordinateRegion(center: spot.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
                cameraMapRegion = MapCameraPosition.region(mapRegion)
            }
            .mapControls {
                MapUserLocationButton()
            }
            Spacer()
        }
        .onAppear {
            if spot.id != nil { // looking at existing spot, center map on spot
                mapRegion = MKCoordinateRegion(center: spot.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
            } else {    // no spot, center on device location
                Task {  // need to wait for map coordinate
                    mapRegion = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: regionSize, longitudinalMeters: regionSize)
                }
                //print("\(mapRegion)")
            }
            cameraMapRegion = MapCameraPosition.region(mapRegion)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(spot.id == nil)
        .toolbar {
            if spot.id == nil { // new spot, show cancel/save buttons
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let success = await spotVM.saveSpot(spot)
                            if success {
                                dismiss()
                            } else {
                                print("Error saving \(spotVM.collectionName) info")
                            }
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showPlaceLookupSheet.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                        Text("Lookup Place")
                    }

                }
            }
        }
        .sheet(isPresented: $showPlaceLookupSheet) {
            PlaceLookupView(returnedSpot: $spot)
        }
    }
}

#Preview {
    NavigationStack {
        SpotDetailView(spot: Spot())
            .environmentObject(SpotViewModel())
            .environmentObject(LocationManager())
    }
}
