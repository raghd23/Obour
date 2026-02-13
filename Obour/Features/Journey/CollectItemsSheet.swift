//
//  CollectItemsSheet.swift
//  Obour
//
//  Created by Deemah Alhazmi on 11/02/2026.
//

import SwiftUI

struct CollectItemsSheet: View {

    @Binding var isPresented: Bool
    @State private var offset: CGFloat = 0

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
                        .frame(width: 260) // adjust size if needed

                    Image(systemName: "airpods.gen3")
                        .font(.system(size: 80))
                        .foregroundStyle(.white)
                }


                Text("لتكتمل الحكاية.. ضع سماعاتك وانطلق.")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Spacer()

                VStack(spacing: 8) {
                    Text("ارفع الشاشة للبدء")
                        .foregroundStyle(.white)

                    Image(systemName: "chevron.down.2")
                        .foregroundStyle(.white)
                }

            }
            .padding()
        }
        .offset(y: offset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height < 0 {
                        offset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height < -120 {
                        withAnimation(.easeInOut) {
                            isPresented = false
                        }
                    } else {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                    }
                }
        )
        .animation(.easeInOut, value: offset)
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



// MARK: - Collect Items Sheet (Temporary - Do Not Remove)
// @State private var showSheet = true

    /*
    if showSheet {
        CollectItemsSheet(isPresented: $showSheet)
            .transition(.move(edge: .bottom))
            .zIndex(1)
    }
    */

