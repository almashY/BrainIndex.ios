import Foundation

/// 手動DI用コンテナ。EditViewModelなどをsheetごとに生成する際に使用
@Observable final class DIContainer {
    let knowhowRepo: KnowhowRepositoryImpl
    let settingsRepo: SettingsRepositoryImpl
    let scheduler: NotificationSchedulerImpl

    init(
        knowhowRepo: KnowhowRepositoryImpl,
        settingsRepo: SettingsRepositoryImpl,
        scheduler: NotificationSchedulerImpl
    ) {
        self.knowhowRepo = knowhowRepo
        self.settingsRepo = settingsRepo
        self.scheduler = scheduler
    }

    func makeEditViewModel() -> EditViewModel {
        EditViewModel(
            getKnowhowByIdUseCase: GetKnowhowByIdUseCase(repository: knowhowRepo),
            saveKnowhowUseCase: SaveKnowhowUseCase(repository: knowhowRepo)
        )
    }
}
