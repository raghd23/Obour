//
//  JourneyView.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import SwiftUI
import AVKit

struct JourneyView: View {
    @State private var showCollectItemsView = false
    @State private var fadeOut = false

    @EnvironmentObject var appState: AppState
    @State private var isMuted: Bool = false
    @State private var viewModel: JourneyViewModel

    init(journey: Journey) {
        _viewModel = State(initialValue: JourneyViewModel(journey: journey))
    }

    var body: some View {
        ZStack {
            Color.black // <<< ensures fade goes to black
                    .ignoresSafeArea()
            background
                .opacity(fadeOut ? 0 : 1)

            content
                .opacity(fadeOut ? 0 : 1)

            if showCollectItemsView {
                Color.black.opacity(0.3) // dim background
                        .ignoresSafeArea()
                        .transition(.opacity)
                CollectItemsSheet(isPresented: $showCollectItemsView)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.height < -120 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showCollectItemsView = false
                                    }
                                }
                            }
                    )
            }
        }
        .animation(.easeInOut, value: showCollectItemsView)
        .ignoresSafeArea()
        .onChange(of: showCollectItemsView) { newValue in
            if !newValue {
                // Fade out entire view smoothly
                withAnimation(.easeInOut(duration: 0.3)) {
                    fadeOut = true
                }
                // Navigate after fade
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    appState.route = .desertWalking(viewModel.journey)
                }
            }
        }
        .onAppear {
            if !isMuted { SoundManger.instance.playBackgroundMusic() }
        }
        .onChange(of: isMuted) { _, newValue in
            newValue ? SoundManger.instance.stopBackgroundMusic() : SoundManger.instance.playBackgroundMusic()
        }
        .onDisappear {
            SoundManger.instance.stopBackgroundMusic()
        }
    }
}

private extension JourneyView {
    var background: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.55, green: 0.05, blue: 0.05)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            LoopingVideoView(videoName: "starsMoving", videoType: "mov")
                .ignoresSafeArea()
                .blendMode(.lighten)
                .opacity(0.4)

            VStack {
                Spacer()
                Image("RedSunMounten")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, -1)
            }
        }
    }

    var topControls: some View {
        HStack {
            Button {
                HapticManger.instance.impact(style: .medium)
                appState.route = .home
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.white)
                    .background(Circle().glassEffect(.clear))
            }

            Spacer()

            Button {
                HapticManger.instance.impact(style: .medium)
                isMuted.toggle()
            } label: {
                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.white)
                    .background(Circle().glassEffect(.clear))
            }
        }
        .foregroundStyle(.black)
        .padding(.horizontal, 24)
        .padding(.top, 60)
    }

    var content: some View {
        VStack {
            topControls
            Spacer()
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 12) {
                    Image(systemName: "moon.dust.fill")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Red\nHorizon ")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(-6)
                        .padding(.bottom, 8)

                    Text("Mystery in the desert, light at the end.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(6)
                        .frame(maxWidth: 260, alignment: .leading)
                }
            }
            .padding(.trailing,100)
            .padding(.bottom, 30)

            HStack {
                startButton

                Button {
                    HapticManger.instance.impact(style: .medium)
                    appState.route = .collection
                } label: {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.white)
                        .background(Circle().glassEffect(.clear).foregroundStyle(.black.opacity(0.01)))
                }
                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }

    var startButton: some View {
        Button {
            HapticManger.instance.impact(style: .medium)
            viewModel.startJourney()
            withAnimation(.easeInOut) {
                showCollectItemsView = true
            }
        } label: {
            Text("Start Your Journey")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background {
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
                 }
         }
     }
 }

 // MARK: - Looping Video View
 struct LoopingVideoView: UIViewRepresentable {
     let videoName: String
     let videoType: String

     func makeUIView(context: Context) -> LoopingPlayerView {
         let view = LoopingPlayerView()

         guard let url = Bundle.main.url(forResource: videoName, withExtension: videoType) else {
             print("❌ Video not found: \(videoName).\(videoType)")
             return view
         }

         view.configure(with: url)
         return view
     }

     func updateUIView(_ uiView: LoopingPlayerView, context: Context) {}
 }

 // MARK: - UIKit Player Container
 final class LoopingPlayerView: UIView {
     private let playerLayer = AVPlayerLayer()
     private var player: AVPlayer?

     override init(frame: CGRect) {
         super.init(frame: frame)
         layer.addSublayer(playerLayer)
         playerLayer.videoGravity = .resizeAspectFill
     }

     required init?(coder: NSCoder) { fatalError() }

     override func layoutSubviews() {
         super.layoutSubviews()
         playerLayer.frame = bounds
     }

     func configure(with url: URL) {
         let player = AVPlayer(url: url)
         player.isMuted = true
         player.actionAtItemEnd = .none

         NotificationCenter.default.addObserver(
             forName: .AVPlayerItemDidPlayToEndTime,
             object: player.currentItem,
             queue: .main
         ) { [weak player] _ in
             player?.seek(to: .zero)
             player?.play()
         }

         self.player = player
         playerLayer.player = player
         player.play()
     }
 }

