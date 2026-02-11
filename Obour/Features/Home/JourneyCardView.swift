//
//  JourneyCardView.swift
//  Obour
//
//  Created by Yousra Abdelrahman on 17/08/1447 AH.
//
import SwiftUI

struct JourneyCardView: View {
    let journey: Journey
    let forwardAction: (() -> Void)? // optional action

    var body: some View {
        ZStack {
            //Background Card
            ForEach(0..<10, id: \.self) { _ in
                    Image("frameCard")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 335, height: 433)
                }
            
            VStack{
//                Spacer()
                // Image from asset name
                if let imageName = journey.imageName {
                    //MARK: - Change later
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width:318 , height: 268)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                
                }
            }

            // Optional outlines
            VStack {
                HStack{
                    HStack{
                        Image(systemName: "leaf")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 6)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                    }
                    .glassEffect(.clear)
                    Spacer()
                    if let outline = journey.outline {
                        Text(outline)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    HStack{
                        Image(systemName: "hourglass")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                        if let subOutline = journey.subOutline {
                            Text(subOutline)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                    }
                    .glassEffect(.clear)
                }
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        forwardAction?() // only runs if action is provided
                        HapticManger.instance.impact(style: .medium)
                        // Sound button logic for current journey
                    }) {
                        Image(systemName: forwardAction == nil ? "lock" : "chevron.forward")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .padding()
  
                    }
                    .buttonStyle(.plain)
                    .frame(width: 40, height: 40)
//                    .glassEffect(.clear.interactive().tint(.black.opacity(0.1)))
                    .glassEffect(forwardAction != nil ? .clear.interactive().tint(.black.opacity(0.1)) : .clear)
                }
                
            }
            .padding()
        }
        .frame(width: 355, height: 433)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(1), radius: 15, y: 8)

    }
}


