import Foundation
import Observation

struct SettingsUiState {
    var isLoading: Bool = false
    var errorMessage: String? = nil
}

@Observable final class SettingsViewModel {
    private let getTodayCountUseCase: GetTodayCountUseCase
    private let updateNotificationSettingsUseCase: UpdateNotificationSettingsUseCase

    var uiState = SettingsUiState()
    var notificationTime: Date = Date()
    var isNotificationEnabled: Bool = false
    var todayCount: Int = 0
    var streakDays: Int = 0

    init(
        getTodayCountUseCase: GetTodayCountUseCase,
        updateNotificationSettingsUseCase: UpdateNotificationSettingsUseCase
    ) {
        self.getTodayCountUseCase = getTodayCountUseCase
        self.updateNotificationSettingsUseCase = updateNotificationSettingsUseCase
    }

    func loadSettings(settingsRepository: SettingsRepository, knowhowRepository: KnowhowRepository) {
        uiState.isLoading = true
        notificationTime = settingsRepository.getNotificationTime()
        isNotificationEnabled = settingsRepository.isNotificationEnabled()
        do {
            todayCount = try getTodayCountUseCase.execute()
            streakDays = try knowhowRepository.getStreakDays()
        } catch {
            uiState.errorMessage = error.localizedDescription
        }
        uiState.isLoading = false
    }

    func onNotificationTimeChange(time: Date) {
        notificationTime = time
        updateNotificationSettingsUseCase.execute(time: time, enabled: isNotificationEnabled)
    }

    func onNotificationEnabledChange(enabled: Bool) {
        isNotificationEnabled = enabled
        updateNotificationSettingsUseCase.execute(time: notificationTime, enabled: enabled)
    }
}
