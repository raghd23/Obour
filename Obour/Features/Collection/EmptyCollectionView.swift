//
//  EmptyCollectionView.swift
//  Obour
//
//  Created by Yousra Abdelrahman on 23/08/1447 AH.
//

import SwiftUI
struct EmptyCollectionView: View {
    var body: some View {
        VStack(spacing: 12) {
            ZStack{
                HStack {
                    Image("emptyItem2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 120)
                        .padding(.trailing, 50)
                    Image("emptyItem3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 120)
                }
                Image("emptyItem1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 120)
                    .padding(.top, 80)
            }
            Text("No items in this collection")
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
            Text("Complete more journeys to collect items.")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
#Preview {
    EmptyCollectionView()
}
