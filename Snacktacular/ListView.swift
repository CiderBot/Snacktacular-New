//
//  ListView.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/27/23.
//

import SwiftUI
import Firebase

struct ListView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Text("List items will go here")
        }
        .listStyle(.plain)
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
                    //TODO: add item code
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ListView()
    }
}
