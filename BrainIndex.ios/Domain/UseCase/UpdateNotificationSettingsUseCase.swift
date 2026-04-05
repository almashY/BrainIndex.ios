import Foundation

final class UpdateNotificationSettingsUseCase {
    private let settingsRepository: SettingsRepository
    private let notificationScheduler: NotificationScheduler

    init(settingsRepository: SettingsRepository, notificationScheduler: NotificationScheduler) {
        self.settingsRepository = settingsRepository
        self.notificationScheduler = notificationScheduler
    }

    func execute(time: Date, enabled: Bool) {
        settingsRepository.saveNotificationTime(time: time)
        settingsRepository.saveNotificationEnabled(enabled: enabled)
        if enabled {
            notificationScheduler.schedule(time: time)
        } else {
            notificationScheduler.cancel()
        }
    }
}
