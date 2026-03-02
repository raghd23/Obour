//
//  CollectionView.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//
import SwiftUI

struct CollectionView: View {
    @EnvironmentObject private var appState: AppState

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
                }
                // MARK: - Scrollable item cards OR empty placeholder
                if discoveredItems.isEmpty {
                    EmptyCollectionView()
                        .padding(.top, 150)
                } else {
                    ScrollView {
                        VStack(spacing: 50) {
                            ForEach(discoveredItems) { item in
                                ItemCardView(item: item)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
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

