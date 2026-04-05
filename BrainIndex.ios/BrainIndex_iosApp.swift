import SwiftUI
import SwiftData

@main
struct BrainIndex_iosApp: App {
    private let container: ModelContainer
    private let diContainer: DIContainer
    @State private var homeViewModel: HomeViewModel
    @State private var reviewViewModel: ReviewViewModel
    @State private var quizViewModel: QuizViewModel
    @State private var settingsViewModel: SettingsViewModel

    init() {
        let modelContainer = try! AppDatabase.makeContainer()
        container = modelContainer

        let context = modelContainer.mainContext
        let knowhowRepo = KnowhowRepositoryImpl(modelContext: context)
        let settingsRepo = SettingsRepositoryImpl()
        let scheduler = NotificationSchedulerImpl()

        diContainer = DIContainer(
            knowhowRepo: knowhowRepo,
            settingsRepo: settingsRepo,
            scheduler: scheduler
        )

        _homeViewModel = State(wrappedValue: HomeViewModel(
            getKnowhowListUseCase: GetKnowhowListUseCase(repository: knowhowRepo),
            deleteKnowhowUseCase: DeleteKnowhowUseCase(repository: knowhowRepo)
        ))
        _reviewViewModel = State(wrappedValue: ReviewViewModel(
            getRandomKnowhowUseCase: GetRandomKnowhowUseCase(repository: knowhowRepo),
            toggleFavoriteUseCase: ToggleFavoriteUseCase(repository: knowhowRepo)
        ))
        _quizViewModel = State(wrappedValue: QuizViewModel(
            generateQuizUseCase: GenerateQuizUseCase(repository: knowhowRepo)
        ))
        _settingsViewModel = State(wrappedValue: SettingsViewModel(
            getTodayCountUseCase: GetTodayCountUseCase(repository: knowhowRepo),
            updateNotificationSettingsUseCase: UpdateNotificationSettingsUseCase(
                settingsRepository: settingsRepo,
                notificationScheduler: scheduler
            )
        ))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(homeViewModel)
                .environment(reviewViewModel)
                .environment(quizViewModel)
                .environment(settingsViewModel)
                .environment(diContainer)
        }
        .modelContainer(container)
    }
}
