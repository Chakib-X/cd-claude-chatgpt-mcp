import SwiftUI

struct MoreTabView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Health Data") {
                    NavigationLink("Neko Screenings") {
                        NekoScreeningListView()
                    }
                    HealthKitAuthorizationView()
                }
                Section("Manage") {
                    NavigationLink("Favorite Foods") {
                        FavoriteFoodsView()
                    }
                    NavigationLink("Supplements") {
                        SupplementListView()
                    }
                }
            }
            .navigationTitle("More")
        }
    }
}
