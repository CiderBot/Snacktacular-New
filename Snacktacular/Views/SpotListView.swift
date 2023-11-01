//
//  SpotListView.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/27/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct SpotListView: View {
    @Environment(\.dismiss) private var dismiss
    @FirestoreQuery(collectionPath: "spots") var spotsList: [Spot]
    @State private var inAddMode = false
    
    var body: some View {
        NavigationStack { //
            List(spotsList) { spot in
                NavigationLink {
                    SpotDetailView(spot: spot)
                } label: {
                    VStack(alignment: .leading) {
                        Text(spot.name)
                            .font(.title2)
                        Text(spot.address)
                            .font(.callout)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Snack Spots")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🪵➡️ Logout Success!")
                            dismiss()
                        } catch {
                            print("😡 SIGN OUT ERROR")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        inAddMode.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $inAddMode, content: {
                NavigationStack {
                    SpotDetailView(spot: Spot())
                }
        })
        }
    }
}

#Preview {
    NavigationStack {
        SpotListView()
    }
}
