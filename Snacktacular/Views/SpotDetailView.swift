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
    @EnvironmentObject var locationManager: LocationManager
    // location manager is also needed for PlaceLookupView to work in preview mode
    
    @State var spot: Spot   // return to SpotListView
    @State private var showPlaceLookupSheet = false
    
    // flag to see if we are running in preview in xCode, set in the preview statement below
    var previewRunning = false
    
    // mapping stuff
    //@State private var cameraRegion = MKCoordinateRegion()
    
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

            //let cameraPosition = findCameraPosition()
            let cameraPosition = findCameraPosition()
            Map(initialPosition: cameraPosition) {
                Annotation("", coordinate: locationManager.location?.coordinate ?? locationManager.appleHQLoc) {
                    Image(systemName: "circle.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                    }
                if spot.latitude != 0.0 {
                    Marker(spot.name, coordinate: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude))
                }
                    
            }
            Spacer()
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
    
    func findCameraPosition() -> MapCameraPosition {
        // returns a position to center the map
        
        // set up the default in case we do not have location info
        var cameraRegion = (locationManager.location == nil) ? locationManager.appleHQReg :
            locationManager.region
        
        if spot.id != nil { // looking at existing spot, center map on spot
            cameraRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude), latitudinalMeters: locationManager.regionSize, longitudinalMeters: locationManager.regionSize)
        }
        
        return MapCameraPosition.region(cameraRegion)
       
    }
}

#Preview {
    NavigationStack {
        SpotDetailView(spot: Spot(), previewRunning: true)
            .environmentObject(SpotViewModel())
            .environmentObject(LocationManager())
    }
}
