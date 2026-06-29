import SwiftUI

struct LogTabView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    NutritionLogView()
                    HydrationLogView()
                    AlcoholLogView()
                    DailySupplementChecklistView()
                }
                .padding()
            }
            .navigationTitle("Log")
        }
    }
}
