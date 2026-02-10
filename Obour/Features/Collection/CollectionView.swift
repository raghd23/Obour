//
//  CollectionView.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//
import SwiftUI

struct CollectionView: View {

    @StateObject private var collectionVM: CollectionViewModel
    @GestureState private var dragOffset = CGSize.zero

    init(journey: Journey) {
        _collectionVM = StateObject(wrappedValue: CollectionViewModel(journey: journey))
    }

    var body: some View {
        ZStack {
            // Background (reuse Home gradient logic later if desired)
            Color.darkGray.ignoresSafeArea()

            VStack{
                // MARK: - Top bar
                HStack {
                    Button {
                        // Back action handled by NavigationStack
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .padding()
                    }
                    .buttonStyle(.plain)
                    .frame(width: 40, height: 40)
                    .glassEffect(.clear.interactive().tint(.black.opacity(0.1)))

                    Spacer()

                    Text("Journey Item")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.trailing, 50)

                    Spacer()
                }
                
                HStack{
                    Text("Collections")
                        .foregroundColor(.white)
                        .font(.caption)

                    Spacer()
                    
                    Text("\(collectionVM.items.count) / 4 items")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .padding(.top, 8)
                .padding(.bottom, 50)
                // MARK: - Stacked item cards
                ZStack {
                    ForEach(Array(collectionVM.items.enumerated()), id: \.1.id) { index, item in
                        ItemCardView(item: item)
                            .offset(y: -CGFloat(index) * 36)
                            .zIndex(Double(collectionVM.items.count - index))
                            .gesture(
                                DragGesture(minimumDistance: 20)
                                    .updating($dragOffset) { value, state, _ in
                                        if abs(value.translation.height) > 20 && index == 0 {
                                            state = value.translation
                                        }
                                    }
                                    .onEnded { value in
                                        if abs(value.translation.height) > 50 && index == 0 {
                                            withAnimation(.spring()) {
                                                collectionVM.rotateItems()
                                            }
                                        }
                                    }
                            )
                    }
                }

                Spacer()
            }
            .frame(maxWidth: 375)
        }
    }
}

#Preview {
    CollectionView(journey: CollectionViewModel.preview.journey)
}
