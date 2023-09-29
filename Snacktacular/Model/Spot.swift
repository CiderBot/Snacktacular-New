//
//  Spot.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/27/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Spot: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address, "latitude": latitude, "longitude": longitude]
    }
}
