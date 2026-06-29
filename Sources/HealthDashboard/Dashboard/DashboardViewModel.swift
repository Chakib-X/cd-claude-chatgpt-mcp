import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var todaySteps: Double = 0
    @Published var todayActiveEnergy: Double = 0
    @Published var todayWorkoutCount: Int = 0
    @Published var latestRestingHeartRate: Double?
    @Published var isLoading = false

    private let healthKitManager: HealthKitManager

    init(healthKitManager: HealthKitManager? = nil) {
        self.healthKitManager = healthKitManager ?? .shared
    }

    func refresh() async {
        isLoading = true
        defer { isLoading = false }

        guard healthKitManager.isAuthorized else { return }

        let start = DateUtilities.startOfDay(Date())
        let end = DateUtilities.endOfDay(Date())

        async let steps = try? healthKitManager.fetchStepCount(start: start, end: end)
        async let energy = try? healthKitManager.fetchActiveEnergy(start: start, end: end)
        async let workouts = try? healthKitManager.fetchWorkouts(start: start, end: end)
        async let restingHeartRate = try? healthKitManager.fetchLatestRestingHeartRate()

        todaySteps = await steps ?? 0
        todayActiveEnergy = await energy ?? 0
        todayWorkoutCount = (await workouts ?? []).count
        latestRestingHeartRate = await restingHeartRate ?? nil
    }
}
