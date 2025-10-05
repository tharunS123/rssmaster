import SwiftUI

// A sharp, minimal "shuriken" style loader that fits the app's dark, Japanese-inspired vibe.
struct ShurikenLoadingView: View {
    @State private var rotate = false

    var body: some View {
        ZStack {
            // Glow
            Circle()
                .fill(RadialGradient(colors: [Color.white.opacity(0.25), Color.clear], center: .center, startRadius: 0, endRadius: 22))
                .blur(radius: 6)
                .frame(width: 44, height: 44)

            // Blades
            ForEach(0..<4) { i in
                ShurikenBlade()
                    .fill(LinearGradient(colors: [Color.white.opacity(0.95), Color.white.opacity(0.25)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 12, height: 34)
                    .rotationEffect(.degrees(Double(i) * 90))
                    .shadow(color: Color.white.opacity(0.18), radius: 3, x: 0, y: 0)
            }

            // Center ring
            Circle()
                .stroke(Color.white.opacity(0.35), lineWidth: 2)
                .frame(width: 10, height: 10)
        }
        .frame(width: 36, height: 36)
        .rotationEffect(rotate ? .degrees(360) : .degrees(0))
        .animation(.linear(duration: 0.8).repeatForever(autoreverses: false), value: rotate)
        .onAppear { rotate = true }
        .accessibilityLabel("Generating")
    }
}

struct ShurikenBlade: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Upward pointing triangle with slightly inset base for a sharper look
        p.move(to: CGPoint(x: w / 2, y: 0))
        p.addLine(to: CGPoint(x: w, y: h - 2))
        p.addLine(to: CGPoint(x: 0, y: h - 2))
        p.closeSubpath()
        return p
    }
}
