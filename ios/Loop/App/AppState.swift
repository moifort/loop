import SwiftUI
import UserNotifications

/// Demo state: the signed-in role and the notifications each role received
@MainActor
@Observable
final class AppState {
    static let shared = AppState()

    /// Launch arguments for demos and screenshots: `-role housekeeping`, `-inbox YES`, `-notify YES`
    var role: Role = Role(rawValue: UserDefaults.standard.string(forKey: "role") ?? "") ?? .reception
    var showInbox = UserDefaults.standard.bool(forKey: "inbox")
    var inbox: [Role: [LoopNotification]] = Dictionary(uniqueKeysWithValues: Role.allCases.map { ($0, $0.history) })

    var notifications: [LoopNotification] { inbox[role] ?? [] }
    var unread: Int { notifications.filter { !$0.read }.count }

    func switchTo(_ role: Role) {
        self.role = role
        updateBadge()
    }

    func markAllRead() {
        inbox[role] = notifications.map { var n = $0; n.read = true; return n }
        updateBadge()
    }

    func markRead(_ id: String) {
        inbox[role] = notifications.map { var n = $0; if n.id == id { n.read = true }; return n }
        updateBadge()
    }

    /// Sends the role's live notification as a real iOS notification, after a short delay so the phone can be locked
    func sendLive(after delay: TimeInterval = 3) {
        let role = role, live = role.live, id = "\(role.rawValue)-live-\(Int(Date.now.timeIntervalSince1970))"
        let content = UNMutableNotificationContent()
        content.title = live.title
        content.subtitle = "Loop · \(role.title)"
        content.body = live.body
        content.sound = live.level == .alert ? .defaultCritical : .default
        content.threadIdentifier = role.rawValue
        content.categoryIdentifier = role.rawValue
        content.interruptionLevel = live.level == .alert ? .timeSensitive : .active
        content.userInfo = ["role": role.rawValue]
        content.badge = NSNumber(value: unread + 1)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
        // The inbox gets it at the same moment, whether the app is open or not
        Task {
            try? await Task.sleep(for: .seconds(delay))
            let time = Date.now.formatted(.dateTime.hour().minute())
            inbox[role, default: []].insert(.init(id: id, role: role, title: live.title, body: live.body, time: time, level: live.level, symbol: live.symbol), at: 0)
            updateBadge()
        }
    }

    private func updateBadge() {
        UNUserNotificationCenter.current().setBadgeCount(unread)
    }
}
