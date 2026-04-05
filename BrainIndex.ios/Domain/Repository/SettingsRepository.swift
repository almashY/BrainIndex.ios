import Foundation

protocol SettingsRepository {
    func getNotificationTime() -> Date
    func saveNotificationTime(time: Date)
    func isNotificationEnabled() -> Bool
    func saveNotificationEnabled(enabled: Bool)
}
