import Foundation
import UserNotifications

final class NotificationSchedulerImpl: NotificationScheduler {
    private let center = UNUserNotificationCenter.current()

    func schedule(time: Date) {
        Task {
            do {
                let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
                guard granted else { return }
                center.removePendingNotificationRequests(withIdentifiers: ["daily_review"])
                let content = UNMutableNotificationContent()
                content.title = "BrainIndex"
                content.body = "今日のノウハウを復習しましょう"
                content.sound = .default
                var components = Calendar.current.dateComponents([.hour, .minute], from: time)
                components.second = 0
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(
                    identifier: "daily_review",
                    content: content,
                    trigger: trigger
                )
                try await center.add(request)
            } catch {
                // 通知許可が拒否された場合は無視
            }
        }
    }

    func cancel() {
        center.removePendingNotificationRequests(withIdentifiers: ["daily_review"])
    }
}
