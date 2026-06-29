import SwiftUI

struct HealthKitAuthorizationView: View {
    @ObservedObject private var healthKitManager = HealthKitManager.shared

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: healthKitManager.isAuthorized ? "heart.fill" : "heart")
                .font(.system(size: 32))
                .foregroundStyle(.red)

            if healthKitManager.isAuthorized {
                Text("Apple Health connected")
                    .font(.subheadline.weight(.semibold))
            } else {
                Text("Connect Apple Health to power your fitness dashboard with workouts, steps, and vitals.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Connect Apple Health") {
                    Task { await healthKitManager.requestAuthorization() }
                }
                .buttonStyle(.borderedProminent)
            }

            if let error = healthKitManager.authorizationError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding()
    }
}
