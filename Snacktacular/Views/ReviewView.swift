//
//  ReviewView.swift
//  Snacktacular
//
//  Created by Steven Yung on 10/2/23.
//

import SwiftUI

struct ReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State var spot: Spot
    @State var review: Review
    @StateObject var reviewVM = ReviewViewModel()
    
    var body: some View {
        VStack {
            
            // title info
            VStack(alignment: .leading) {
                Text(spot.name)
                    .font(.title)
                    .bold()
                Text(spot.address)
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // star rating
            VStack {    // not really needed but done for group purposes
                Text("Click to Rate:")
                    .font(.title2)
                    .bold()
                HStack {
                    StarSelectionView(rating: $review.rating)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray .opacity(0.5), lineWidth: 2)
                        }
                }
            }
            .padding(.vertical)
            
            VStack(alignment: .leading) {
                Text("Review Title:")
                    .bold()
                TextField("title", text: $review.title)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray .opacity(0.5), lineWidth: 2)
                    }
                Text("Review:")
                    .bold()
                TextField("review", text: $review.body)
                    .padding(.horizontal, 6)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray .opacity(0.5), lineWidth: 2)
                    }
            }
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        let success = await reviewVM.saveReview(spot:spot, review: review)
                        if success {
                            // can put dismiss here
                        } else {
                            // can put some sort of error processing here
                        }
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ReviewView(spot: Spot(name: "Shake Shack", address: "49 Boyleston Street, Chestnut Hill, MA"), review: Review())
    }
}
