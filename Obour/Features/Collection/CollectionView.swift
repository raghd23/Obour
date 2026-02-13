//
//  CollectionView.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//
import SwiftUI

struct CollectionView: View {
    @EnvironmentObject private var appState: AppState
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
                        HapticManger.instance.impact(style: .medium)
                        appState.route = .journeyV
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
                
                if collectionVM.items.isEmpty{
                    
                } else {
                    HStack{
                        Text("Collections")
                            .foregroundColor(.white)
                            .font(.caption)
                        
                        Spacer()
                        
                        Text("\(collectionVM.items.count) / 2 items")
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 50)
                }
                // MARK: - Stacked item cards
                // MARK: - Stacked item cards OR empty placeholder
                ZStack {
                    if collectionVM.items.isEmpty {
                        EmptyCollectionView()
                            .padding(.top, 150)
                    } else {
                        ForEach(Array(collectionVM.items.enumerated()), id: \.1.id) { index, item in
                            ItemCardView(item: item)
                                .offset(y: -CGFloat(index) * 36)
                                .zIndex(Double(collectionVM.items.count - index))
                                .onAppear {
                                    // Placeholder curtain call
                                    collectionVM.curtainShowItem(byID: item.id)
                                }
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
                }
                
                
                Spacer()
            }
            .frame(maxWidth: 375)
        }
    }
}

//#Preview {
//    CollectionView(journey: CollectionViewModel.preview.journey)
//
//}

#Preview {
    // Create a temporary Journey for preview
    let previewJourney = Journey(
        id: "preview-journey",
        title: "Experimental Journey",
        description: "Used for preview only",
        outline: nil,
        subOutline: nil,
        imageName: nil,
        scenes: [],
        items: [], // start empty
        requiredItemIDs: [],
        journeyRules: JourneyRules(
            softLimitSeconds: 0,
            hardLimitSeconds: 0,
            lostNoProgressSeconds: 0,
            graceVolumeMultiplier: 1,
            lostVolumeMultiplier: 1
        )
    )

    // Create the ViewModel for preview
    let previewVM = CollectionViewModel(journey: previewJourney)

    // Add some items for preview
    ItemData.allItems.prefix(2).forEach { previewVM.addItem($0) }

    // Return the view
    return CollectionView(journey: previewJourney)
        .environmentObject(previewVM)
}

