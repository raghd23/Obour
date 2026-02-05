//
//  HomeView.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var homeVM = HomeViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                homeVM.backgroundGradient().ignoresSafeArea()
                VStack{
                    HStack{
                        Button{
                            
                        } label:{
                            Text("Hello World")
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
