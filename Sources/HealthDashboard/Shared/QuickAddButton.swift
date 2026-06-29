import SwiftUI

struct QuickAddButton: View {
    let title: String
    let systemImage: String
    var tint: Color = .accentColor
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.title2)
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .frame(minWidth: 72, minHeight: 64)
            .padding(8)
            .background(tint.opacity(0.15))
            .foregroundStyle(tint)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
