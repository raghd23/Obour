//
//  CollectItemsSheet.swift
//  Obour
//
//  Created by Deemah Alhazmi on 11/02/2026.
//

import SwiftUI

struct CollectItemsSheet: View {

    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color("SheetBG")
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()
                
                ZStack {
                    Image("OrangeCircle")
                        .resizable()
                        .scaleEffect(1.2)
                        .scaledToFit()
                        .frame(width: 260)

                    Image(systemName: "airpods.gen3")
                        .font(.system(size: 80))
                        .foregroundStyle(.white)
                }

                Text("To complete your experience\nplace your headphones and start")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Spacer()

                VStack(spacing: 16) {
                    Text("Swipe Up")
                        .foregroundStyle(.white)

                    Image(systemName: "chevron.up.2")
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 30)
            }
            .padding()
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .zIndex(1)
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var showSheet = true

    var body: some View {
        CollectItemsSheet(isPresented: $showSheet)
    }
}
