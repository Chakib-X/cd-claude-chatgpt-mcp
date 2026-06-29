import SwiftUI

/// Phase A placeholder — real HealthKit authorization request lands in Phase B.
struct HealthKitAuthorizationView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.fill")
                .font(.system(size: 32))
                .foregroundStyle(.red)
            Text("Apple Health connection arrives in Phase B.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
