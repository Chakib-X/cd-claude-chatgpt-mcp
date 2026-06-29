import SwiftUI

/// Phase A placeholder — PDF import + parsing lands in Phase C.
struct NekoScreeningListView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("Neko Health screening import arrives in Phase C.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .navigationTitle("Neko Screenings")
    }
}
