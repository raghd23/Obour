//
//  ItemCardView.swift
//  Obour
//
//  Created by Yousra Abdelrahman on 21/08/1447 AH.
//

import SwiftUI

struct ItemCardView: View {

    let item: Items

    var body: some View {
        ZStack {
            //Background Card
            ForEach(0..<15, id: \.self) { _ in
                    Image("frameCard")
                        .resizable()
                        .scaledToFill()
                }
            
            VStack{
                Image(item.imageAsset)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 355, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                HStack {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    Spacer()
                    
                }
                HStack{
                    Text(item.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(5)
                        .padding(.leading, 10)
                    Spacer()
                }
                HStack{
                    Image(systemName:"hazardsign.fill")
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
