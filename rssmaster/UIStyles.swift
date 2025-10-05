import SwiftUI

// A sharp, minimal button style with a black-to-grey gradient and right angles.
struct DarkGradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.black, Color(white: 0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .brightness(configuration.isPressed ? -0.1 : 0)
            )
            .overlay(
                Rectangle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
            )
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// Subtle paper-like background with light horizontal rules and a thin border.
struct NotepadBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            // Paper base color adapts to light/dark
            (colorScheme == .dark ? Color(white: 0.10) : Color(white: 0.98))

            GeometryReader { geo in
                let spacing: CGFloat = 22
                Path { path in
                    var y: CGFloat = 0
                    while y <= geo.size.height {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geo.size.width, y: y))
                        y += spacing
                    }
                }
                .stroke(
                    (colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.06)),
                    lineWidth: 0.5
                )
            }
        }
        .overlay(
            Rectangle()
                .stroke(
                    (colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.12)),
                    lineWidth: 1
                )
        )
        .clipped()
    }
}
