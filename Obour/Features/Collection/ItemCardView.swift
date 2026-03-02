//
//  ItemCardView.swift
//  Obour
//
//  Created by Yousra Abdelrahman on 21/08/1447 AH.
//

import SwiftUI

struct ItemCardView: View {
    let item: Item  

    var body: some View {
        ZStack {
            // Background Card
            ForEach(0..<15, id: \.self) { _ in
                Image("frameCard")
                    .resizable()
                    .scaledToFill()
            }
            
            VStack {
                // Item image
                if let imageName = item.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 355, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.yellow)
                }
                
                // Item name
                HStack {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    Spacer()
                }
                
                // Item description
                HStack {
                    Text(item.description ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(5)
                        .padding(.leading, 10)
                    Spacer()
                }
                
                // Badge (Not Poisonous)
                HStack {
                    Image(systemName: "hazardsign.fill")
                        .foregroundColor(Color.yellow)
                    
                    Text("Not Poisonous")
                        .font(.caption)
                        .foregroundColor(.white)
                        .lineLimit(5)
                        .padding(.leading, 10)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                }
                .glassEffect(.clear)
            }
        }
        .frame(width: 375, height: 380)
        .shadow(radius: 12)
    }
}
