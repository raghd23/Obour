//
//  EndView.swift
//  Obour
//
//  Created by Yousra Abdelrahman on 15/08/1447 AH.
//
import SwiftUI

struct EndView: View {
    @EnvironmentObject var appState: AppState
    // The UI shown when the journey ends
    var body: some View {
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            Image("blurredBackground")
                .resizable()
                .scaleEffect(1.2)
           
            VStack(spacing: 32) {
                Spacer()
                Image(systemName: "flag.pattern.checkered")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 63, height: 63)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                Text("The journey ended as it was meant to be lived")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .bold(true)
                    .multilineTextAlignment(.center)

                Text("Every item you picked up carries a little story of you, and the items you collected have become a witness to your passage…")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .multilineTextAlignment(.center)
                    
                Text("A mark that remains, and a proof that you have arrived")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.bottom, 32)
                    .bold(true)
                    .multilineTextAlignment(.center)
                Spacer()
                Button {
                    HapticManger.instance.impact(style: .medium)
                    appState.route = .collection
                } label: {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.white)
                        .background(
                            Circle().glassEffect(.clear).foregroundStyle(.black)
                        )
                }
                
                
            }
            .padding()
        }
    }
}

#Preview {
    EndView()
}
