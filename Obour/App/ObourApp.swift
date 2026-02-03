//
//  ObourApp.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//
import SwiftUI

@main
struct ObourApp: App {
    @StateObject private var appState = AppState()

    // If you need an app delegate, uncomment the next line and ensure AppDelegate has no @main
    // @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some SwiftUI.Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
