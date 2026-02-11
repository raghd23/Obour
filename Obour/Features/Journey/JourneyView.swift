//
//  JourneyView.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import SwiftUI

// MARK: - Journey Main View
//
struct JourneyView: View {
    @State private var isMuted: Bool = false

    @State private var viewModel: JourneyViewModel

    // Custom initializer to inject the Journey model
    init(journey: Journey) {
        _viewModel = State(initialValue: JourneyViewModel(journey: journey))
    }

    var body: some View {
        ZStack {
            // Background layer (image / gradient)
            background

            // Foreground content (UI elements)
            content
        }
        // Makes the design full screen (behind status bar & home indicator)
        .ignoresSafeArea()
    }
}

//
// MARK: - Background
//
private extension JourneyView {

    // Background with gradient + bottom-positioned image
    var background: some View {
        ZStack {
            Image("stars")
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.55, green: 0.05, blue: 0.05) // deep red
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            Image("stars")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .offset(y: -100)
                .opacity(0.15)
            VStack {
                Spacer()

                Image("RedSun")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}


//
// MARK: - Top Controls (Audio + Info)
//
private extension JourneyView {

    var topControls: some View {
        HStack {

            Button {
                // audio toggle later
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .glassEffect()
                    )
            }

            Spacer()

            Button {
                isMuted.toggle()
            } label: {
                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .glassEffect(.clear)
                    )
            }

        }
        .foregroundStyle(.black)
        .padding(.horizontal, 24)
        .padding(.top, 30)
    }
}


//
// MARK: - Main Content
//
private extension JourneyView {

    // Main layout of the screen
    var content: some View {
        VStack {
            // Top buttons
            topControls

            Spacer()

            // Text block positioned bottom-right
            HStack {
                Spacer() // pushes content to the right

                VStack(alignment: .trailing, spacing: 12) {

                    // Icon above the title
                    Image(systemName: "moon.dust.fill")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)

                    // Title (Figma-style)
                    Text("المدى\nالأحمر")
                        .font(.system(size: 48, weight: .bold))   // ⬅️ bigger than largeTitle
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.trailing)
                        .lineSpacing(-6)                           // ⬅️ tighter like Figma
                        .padding(.bottom, 8)

                    // Journey description
                    Text("ارتحل مع الرحلة عبر سكون الصحراء، حيث يقودك الغموض في رمالها إلى النور.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.trailing)
                        .lineSpacing(6)
                        .frame(maxWidth: 260, alignment: .trailing) // ⬅️ narrower text block
                }

            }
            .padding(.horizontal, 32)
            .padding(.bottom, 30)

            HStack {
                Spacer() // ⬅️ pushes everything to the right

                Button {
                    // info action later
                } label: {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.white)
                        .background(
                            Circle()
                                .glassEffect(.clear)
                                .foregroundStyle(.black.opacity(0.01))
                        )
                }

                startButton
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)

            
            
        }
    }
}


//
// MARK: - Start Button
//
private extension JourneyView {

    // Button that starts the journey
    var startButton: some View {
        Button {
            // Trigger journey start logic in ViewModel
            viewModel.startJourney()
        } label: {
            Text("ابدأ رحلتك")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background {
                                ZStack {
                                    // 1️⃣ Radiant gradient core
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.75, green: 0.25, blue: 0.2),
                                                    Color(red: 0.35, green: 0.12, blue: 0.1)
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                            .opacity(0.25)
                                        )
                                        .glassEffect(.clear)
                                      //  .opacity(0.25)
                                }
                            }

        }
        
    }
}


#Preview {
    JourneyView(
        journey: Journey(
            id: "preview-journey",
            title: "ر",
            description: "ارتحل مع الرحلة عبر سكون الصحراء، حيث يقودك الغموض في رمالها إلى النور",
            scenes: [],
            items: [],
            requiredItemIDs: [],
            journeyRules: JourneyRules(
                softLimitSeconds: 480,
                hardLimitSeconds: 600,
                lostNoProgressSeconds: 120,
                graceVolumeMultiplier: 1.2,
                lostVolumeMultiplier: 1.6
            )
        )
    )
    .preferredColorScheme(.dark)
}
