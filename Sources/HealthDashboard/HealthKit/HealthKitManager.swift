import Foundation
import HealthKit

@MainActor
final class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()

    private let healthStore = HKHealthStore()
    @Published var isAuthorized = false
    @Published var authorizationError: String?

    var isHealthDataAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization() async {
        guard isHealthDataAvailable else {
            authorizationError = "Health data is not available on this device."
            return
        }
        do {
            try await healthStore.requestAuthorization(toShare: [], read: HealthKitTypes.readTypes)
            isAuthorized = true
            authorizationError = nil
        } catch {
            authorizationError = error.localizedDescription
        }
    }

    func fetchStepCount(start: Date, end: Date) async throws -> Double {
        try await sumQuantity(.stepCount, unit: .count(), start: start, end: end)
    }

    func fetchActiveEnergy(start: Date, end: Date) async throws -> Double {
        try await sumQuantity(.activeEnergyBurned, unit: .kilocalorie(), start: start, end: end)
    }

    func fetchRestingEnergy(start: Date, end: Date) async throws -> Double {
        try await sumQuantity(.basalEnergyBurned, unit: .kilocalorie(), start: start, end: end)
    }

    func fetchDistanceWalkingRunning(start: Date, end: Date) async throws -> Double {
        try await sumQuantity(.distanceWalkingRunning, unit: .meterUnit(with: .kilo), start: start, end: end)
    }

    func fetchLatestRestingHeartRate() async throws -> Double? {
        try await latestQuantitySample(.restingHeartRate, unit: HKUnit(from: "count/min"))
    }

    func fetchAverageRestingHeartRate(start: Date, end: Date) async throws -> Double? {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .restingHeartRate) else { return nil }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let descriptor = HKStatisticsQueryDescriptor(
            predicate: HKSamplePredicate.quantitySample(type: quantityType, predicate: predicate),
            options: .discreteAverage
        )
        let statistics = try await descriptor.result(for: healthStore)
        return statistics?.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min"))
    }

    func fetchLatestBodyFatPercentage() async throws -> Double? {
        try await latestQuantitySample(.bodyFatPercentage, unit: .percent())
    }

    func fetchLatestBodyMass() async throws -> Double? {
        try await latestQuantitySample(.bodyMass, unit: .gramUnit(with: .kilo))
    }

    func fetchWorkouts(start: Date, end: Date) async throws -> [HKWorkout] {
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.workout(predicate)],
            sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)]
        )
        return try await descriptor.result(for: healthStore)
    }

    // MARK: - Generic helpers

    private func sumQuantity(
        _ identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async throws -> Double {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else { return 0 }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let descriptor = HKStatisticsQueryDescriptor(
            predicate: HKSamplePredicate.quantitySample(type: quantityType, predicate: predicate),
            options: .cumulativeSum
        )
        let statistics = try await descriptor.result(for: healthStore)
        return statistics?.sumQuantity()?.doubleValue(for: unit) ?? 0
    }

    private func latestQuantitySample(
        _ identifier: HKQuantityTypeIdentifier,
        unit: HKUnit
    ) async throws -> Double? {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else { return nil }
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: quantityType)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: 1
        )
        let samples = try await descriptor.result(for: healthStore)
        return samples.first?.quantity.doubleValue(for: unit)
    }
}
