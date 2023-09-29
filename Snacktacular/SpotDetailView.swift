//
//  SpotDetailView.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/27/23.
//

import SwiftUI

struct SpotDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var spotVM : SpotViewModel
    @State var spot: Spot
    
    @State private var showPlaceLookupSheet = false
    
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
}

#Preview {
    NavigationStack {
        SpotDetailView(spot: Spot())
            .environmentObject(SpotViewModel())
    }
}
