//
//  StarSelectionView.swift
//  Snacktacular
//
//  Created by Steven Yung on 10/2/23.
//

import SwiftUI

struct StarSelectionView: View {
    @State var rating: Int
    let highestRating = 5
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    let fontSize: Font = .largeTitle
    let fillColor: Color = .yellow
    let emptyColor: Color = .gray
    
    var body: some View {
        HStack {
            ForEach(1...highestRating, id: \.self) { number in
                showStar(for: number)
                    .foregroundColor(number <= rating ? fillColor : emptyColor)
                    .onTapGesture {
                        rating = number
                    }
            }
            .font(fontSize)
        }
    }
    
    func showStar(for currentNumber: Int) -> Image {
        if currentNumber > rating {
            return unselected
        } else {
            return selected
        }
    }
}

#Preview {
    StarSelectionView(rating: 4)
}
