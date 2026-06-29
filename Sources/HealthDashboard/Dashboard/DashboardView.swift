import SwiftUI
import SwiftData

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @ObservedObject private var healthKitManager = HealthKitManager.shared

    @Query private var nutritionEntries: [NutritionEntry]
    @Query private var hydrationEntries: [HydrationEntry]
    @Query private var alcoholEntries: [AlcoholEntry]
    @Query(filter: #Predicate<Supplement> { $0.isActive }) private var activeSupplements: [Supplement]
    @Query(sort: \NekoScreening.screeningDate, order: .reverse) private var screenings: [NekoScreening]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if !healthKitManager.isAuthorized {
                        HealthKitAuthorizationView()
                    }

                    TodaySummaryCard(
                        steps: viewModel.todaySteps,
                        activeEnergy: viewModel.todayActiveEnergy,
                        workoutCount: viewModel.todayWorkoutCount,
                        restingHeartRate: viewModel.latestRestingHeartRate
                    )

                    SectionCard(title: "Today's Logs") {
                        let todayNutrition = NutritionViewModel.entries(nutritionEntries, on: Date())
                        let todayHydration = HydrationViewModel.entries(hydrationEntries, on: Date())
                        let todayAlcohol = AlcoholViewModel.entries(alcoholEntries, on: Date())

                        logRow(label: "Calories", value: "\(NutritionViewModel.totalCalories(todayNutrition)) kcal")
                        logRow(label: "Hydration", value: UnitFormatting.liters(fromMilliliters: HydrationViewModel.totalMilliliters(todayHydration)))
                        logRow(label: "Alcohol", value: UnitFormatting.units(AlcoholViewModel.totalUnits(todayAlcohol)))
                        logRow(label: "Supplement adherence", value: UnitFormatting.percent(SupplementViewModel.adherencePercent(activeSupplements)))
                    }

                    if let latestScreening = screenings.first {
                        BaselineAlignmentView(screening: latestScreening, dashboardViewModel: viewModel)
                    }

                    WeeklyTrendChartsView()
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .task {
                await viewModel.refresh()
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }

    private func logRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value).foregroundStyle(.secondary)
        }
        .font(.subheadline)
    }
}
