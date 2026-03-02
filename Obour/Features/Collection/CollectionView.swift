//
//  CollectionView.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//
import SwiftUI

struct CollectionView: View {
    @EnvironmentObject private var appState: AppState
    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        ZStack {
            Color.darkGray.ignoresSafeArea()

            VStack{
                // MARK: - Top bar
                HStack {
                    Button {
                        HapticManger.instance.impact(style: .medium)
                        appState.route = .journeyV
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
                    
                    Text("Journey Items")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.trailing, 50)
                    
                    Spacer()
                }
                
                // ✅ Get discovered items from AppState
                let discoveredItems = appState.discoveredItems
                
                if discoveredItems.isEmpty {
                    // Empty state will show below
                } else {
                    HStack{
                        Text("Collections")
                            .foregroundColor(.white)
                            .font(.caption)
                        
                        Spacer()
                        
                        Text(appState.discoveryProgress)
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 50)
                }
                
                // MARK: - Stacked item cards OR empty placeholder
                ZStack {
                    if discoveredItems.isEmpty {
                        EmptyCollectionView()
                            .padding(.top, 150)
                    } else {
                        ForEach(Array(discoveredItems.enumerated()), id: \.1.id) { index, item in
                            ItemCardView(item: item)
                                .offset(y: -CGFloat(index) * 36)
                                .zIndex(Double(discoveredItems.count - index))
                                .gesture(
                                    DragGesture(minimumDistance: 20)
                                        .updating($dragOffset) { value, state, _ in
                                            if abs(value.translation.height) > 20 && index == 0 {
                                                state = value.translation
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

#Preview {
    CollectionView()
        .environmentObject(AppState())
}

