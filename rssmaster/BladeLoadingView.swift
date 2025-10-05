import SwiftUI

// A sharp, minimal loader that fits the dark, Japanese-inspired vibe.
struct BladeLoadingView: View {
    @State private var rotate = false

    var body: some View {
        ZStack {
            ForEach(0..<6) { i in
                Capsule()
                    .fill(LinearGradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 4, height: 24)
                    .offset(y: -16)
                    .rotationEffect(.degrees(Double(i) * 60))
                    .opacity(0.6)
            }
        }
        .frame(width: 44, height: 44)
        .rotationEffect(rotate ? .degrees(360) : .degrees(0))
        .animation(.linear(duration: 0.9).repeatForever(autoreverses: false), value: rotate)
        .onAppear { rotate = true }
        .accessibilityLabel("Loading")
    }
}
