//
//  HomeViewModel.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    // Converts Figma-style 0–255 RGB values to SwiftUI Color
    func calculateRGB(r: Double, g: Double, b: Double, o: Double) -> Color{
        Color(
            red: r/255,
            green: g/255,
            blue: b/255,
            opacity: o
        )
    }
    func backgroundGradient() -> LinearGradient{
        LinearGradient(
            gradient:
                Gradient(stops: [
                    Gradient.Stop(color: calculateRGB(r: 80,g: 22, b: 10, o: 1), location: 0.37),
                    Gradient.Stop(color: calculateRGB(r: 34,g: 7, b: 2, o: 1), location: 1.0)
                ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
