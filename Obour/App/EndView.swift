//
//  EndView.swift
//  Obour
//
//  Created by Yousra Abdelrahman on 15/08/1447 AH.
//
import SwiftUI

struct EndView: View {
    // The UI shown when the journey ends
    var body: some View {
        VStack(spacing: 16) {
            Text("Thank you for crossing with Obour")
                .font(.title2)

            Text("Take a moment before returning.")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

