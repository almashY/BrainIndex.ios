import Foundation

final class SettingsRepositoryImpl: SettingsRepository {
    private let defaults: UserDefaults
    private let notificationTimeKey = "notificationTime"
    private let notificationEnabledKey = "notificationEnabled"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func getNotificationTime() -> Date {
        if let saved = defaults.object(forKey: notificationTimeKey) as? Date {
            return saved
        }
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    func saveNotificationTime(time: Date) {
        defaults.set(time, forKey: notificationTimeKey)
    }

    func isNotificationEnabled() -> Bool {
        defaults.bool(forKey: notificationEnabledKey)
    }

    func saveNotificationEnabled(enabled: Bool) {
        defaults.set(enabled, forKey: notificationEnabledKey)
    }
}
