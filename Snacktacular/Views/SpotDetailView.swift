//
//  SpotDetailView.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/27/23.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift

struct SpotDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var spotVM : SpotViewModel
    @EnvironmentObject var locationManager: LocationManager
    // location manager is also needed for PlaceLookupView to work in preview mode
    
    @State var spot: Spot   // return to SpotListView
    @State private var showPlaceLookupSheet = false
    @State private var showReviewViewSheet = false
    
    // the real path can not be set here, it will be done in onAppear
    //@FirestoreQuery(collectionPath: "spots") var spotsList: [Spot]
    
    // flag to see if we are running in preview in xCode, set in the preview statement below
    var previewRunning = false
    
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
            .frame(height: 250)
            
            List {
                Section {
                    /*
                    ForEach(reviews) { review in
                        NavigationLink {
                            ReviewView(spot: spot, review: review)
                        } label: {
                            Text(review.title)
                        }
                    }*/
                } header: {
                    HStack {
                        Text("Avg. Rating:")
                            .font(.title2)
                            .bold()
                        Text("4.5")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(Color("SnackColor"))
                        Spacer()
                        Button("Rate It") {
                            showReviewViewSheet.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .bold()
                        .tint(Color("SnackColor"))
                    }
                }
            }
            .listStyle(.plain)
            .headerProminence(.increased)
            
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
        .sheet(isPresented: $showReviewViewSheet) {
            NavigationStack {
                ReviewView(spot: spot, review: Review())
            }
        }
        .onAppear {
            if !previewRunning {
                //$reviews.path = "spots/\(spot.id ?? "")/reviews"
                //print("reviews.path = \($reviews.path)")
            }
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
