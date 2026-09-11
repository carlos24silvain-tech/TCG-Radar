import SwiftUI

struct ContentView: View {
    @State private var huntMode = true
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView(huntMode: $huntMode)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            DropsView()
                .tabItem {
                    Label("Drops", systemImage: "dot.radiowaves.left.and.right")
                }
                .tag(1)

            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "camera.viewfinder")
                }
                .tag(2)

            CollectionView()
                .tabItem {
                    Label("Collection", systemImage: "square.stack.3d.up.fill")
                }
                .tag(3)

            AnalyticsView()
                .tabItem {
                    Label("AI", systemImage: "brain.head.profile")
                }
                .tag(4)
        }
        .tint(.orange)
    }
}
