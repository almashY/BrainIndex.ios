import SwiftUI

struct RootView: View {
    @Environment(HomeViewModel.self) private var homeVM
    @Environment(ReviewViewModel.self) private var reviewVM
    @Environment(QuizViewModel.self) private var quizVM
    @Environment(SettingsViewModel.self) private var settingsVM

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("ホーム", systemImage: "house") }

            ReviewView()
                .tabItem { Label("復習", systemImage: "book.fill") }

            QuizView()
                .tabItem { Label("クイズ", systemImage: "questionmark.circle") }

            SettingsView()
                .tabItem { Label("設定", systemImage: "gearshape") }
        }
    }
}
