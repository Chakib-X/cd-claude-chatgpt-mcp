import SwiftUI
import SwiftData

struct WeeklyGoalsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WeeklyGoal.weekStartDate, order: .reverse) private var allGoals: [WeeklyGoal]
    @Query private var nutritionEntries: [NutritionEntry]
    @Query private var hydrationEntries: [HydrationEntry]
    @Query private var supplements: [Supplement]

    @State private var isAddingGoal = false
    @State private var editingGoal: WeeklyGoal?

    private var currentWeekGoals: [WeeklyGoal] {
        let weekStart = DateUtilities.startOfWeek(containing: Date())
        return allGoals.filter { $0.weekStartDate == weekStart }
    }

    var body: some View {
        NavigationStack {
            List {
                if currentWeekGoals.isEmpty {
                    ContentUnavailableView(
                        "No Goals This Week",
                        systemImage: "target",
                        description: Text("Add a weekly goal, optionally tied to your Neko baseline.")
                    )
                } else {
                    ForEach(currentWeekGoals) { goal in
                        WeeklyGoalRow(
                            goal: goal,
                            nutritionEntries: nutritionEntries,
                            hydrationEntries: hydrationEntries,
                            supplements: supplements
                        )
                        .onTapGesture { editingGoal = goal }
                    }
                    .onDelete(perform: deleteGoals)
                }
            }
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isAddingGoal = true
                    } label: {
                        Label("Add Goal", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingGoal) {
                EditWeeklyGoalView()
            }
            .sheet(item: $editingGoal) { goal in
                EditWeeklyGoalView(goal: goal)
            }
        }
    }

    private func deleteGoals(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(currentWeekGoals[index])
        }
    }
}

private struct WeeklyGoalRow: View {
    let goal: WeeklyGoal
    let nutritionEntries: [NutritionEntry]
    let hydrationEntries: [HydrationEntry]
    let supplements: [Supplement]

    @State private var currentValue: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(goal.title)
                .font(.headline)
            ProgressView(value: GoalProgressCalculator.progressFraction(currentValue: currentValue, target: goal.targetValue))
            HStack {
                Text("\(currentValue, specifier: "%.1f") / \(goal.targetValue, specifier: "%.1f") \(goal.unit)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if goal.linkedBaselineMetricKey != nil {
                    Text("Linked to baseline")
                        .font(.caption2)
                        .foregroundStyle(.tint)
                }
            }
        }
        .task {
            currentValue = await GoalProgressCalculator.currentValue(
                for: goal,
                nutritionEntries: nutritionEntries,
                hydrationEntries: hydrationEntries,
                supplements: supplements
            )
        }
    }
}
