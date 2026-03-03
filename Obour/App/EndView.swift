import SwiftUI

struct EndView: View {
    @EnvironmentObject var appState: AppState
    @State private var contentOpacity: Double = 0
    @State private var blackOverlayOpacity: Double = 0

    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()

            Image("blurredBackground")
                .resizable()
                .scaleEffect(1.2)

            VStack(spacing: 32) {
                Spacer()

                Image(systemName: "flag.pattern.checkered")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 63, height: 63)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)

                Text("The journey ended as it was meant to be lived")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .bold(true)
                    .multilineTextAlignment(.center)

                Text("Every item you picked up carries a little story of you, and the items you collected have become a witness to your passage…")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .multilineTextAlignment(.center)

                Text("A mark that remains, and a proof that you have arrived")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.bottom, 32)
                    .bold(true)
                    .multilineTextAlignment(.center)

                Spacer()

                Button {
                    // Fade out on button tap
                    withAnimation(.easeIn(duration: 1)) {
                        blackOverlayOpacity = 1
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        HapticManger.instance.impact(style: .medium)
                        appState.route = .collection
                    }
                } label: {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.white)
                        .background(
                            Circle().glassEffect(.clear).foregroundStyle(.black)
                        )
                }

            }
            .padding()
            .opacity(contentOpacity) // Fade-in for the content

            // Black overlay for fade-out effect
            Color.black
                .ignoresSafeArea()
                .opacity(blackOverlayOpacity)
        }
        .onAppear {
            // Fade in content smoothly
            withAnimation(.easeIn(duration: 1.5)) {
                contentOpacity = 1
            }
        }
    }
}

#Preview {
    EndView()
}
