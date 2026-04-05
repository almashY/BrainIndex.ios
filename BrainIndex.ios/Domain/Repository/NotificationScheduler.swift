import Foundation

protocol NotificationScheduler {
    func schedule(time: Date)
    func cancel()
}
