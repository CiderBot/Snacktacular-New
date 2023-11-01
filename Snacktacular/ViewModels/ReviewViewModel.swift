//
//  ReviewViewModel.swift
//  Snacktacular
//
//  Created by Steven Yung on 11/1/23.
//

import Foundation
import FirebaseFirestore

class ReviewViewModel: ObservableObject {
    @Published var review = Review()
    
    func saveReview(spot: Spot, review: Review) async -> Bool {
        let db = Firestore.firestore()
        
        guard let spotID = spot.id else {
            print("😡 ERROR: spot.id = nil")
            return false
        }
        let collectionName = "spots/\(spotID)/reviews"
        
        if let id = review.id {   // spot must already exist, so save
            // note that the app will not let you update an existing spot but putting code here anyway to show how it is done
            do {
                try await db.collection(collectionName).document(id).setData(review.dictionary)
                print("😎 Data for '\(collectionName)' updated successfull!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in '\(collectionName)' \(error.localizedDescription)")
                return false
            }
        } else {    // no id, must be new review to add
            do {
                // addDocument will return a document reference which we are not using
                _ = try await db.collection(collectionName).addDocument(data: review.dictionary)
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
