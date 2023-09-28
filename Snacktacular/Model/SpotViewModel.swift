//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/28/23.
//

import Foundation
import FirebaseFirestore

class SpotViewModel: ObservableObject {
    @Published var spot = Spot()
    
    let collectionName = "spots"
    
    func saveSpot(_ spot: Spot) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = spot.id {   // spot must already exist, so save
            // note that the app will not let you update an existing spot but putting code here anyway to show how it is done
            do {
                try await db.collection(collectionName).document(id).setData(spot.dictionary)
                print("😎 Data for '\(collectionName)' updated successfull!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in '\(collectionName)' \(error.localizedDescription)")
                return false
            }
        } else {    // no id, must be new spot to add
            do {
                try await db.collection(collectionName).addDocument(data: spot.dictionary)
                // note: firebase will generate the id on add
                print("😎 Data for '\(collectionName)' addeded successfull!")
                return true
            } catch {
                print("😡 ERROR: Could not add data in '\(collectionName)' \(error.localizedDescription)")
                return false
            }
        }
    }
}
