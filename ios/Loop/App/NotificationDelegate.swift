import UserNotifications

/// Shows Loop notifications as banners even when the app is open, and opens the right role when one is tapped
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate, Sendable {
    static let shared = NotificationDelegate()

    /// Asks for permission and registers one action set per role (long-press on the notification)
    func setUp() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.setNotificationCategories(Set(Role.allCases.map { role in
            UNNotificationCategory(identifier: role.rawValue, actions: Self.actions(for: role), intentIdentifiers: [])
        }))
        // `-captures YES`: no permission prompt over the screenshots
        guard !UserDefaults.standard.bool(forKey: "captures") else { return }
        center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    private static func actions(for role: Role) -> [UNNotificationAction] {
        let titles: [String] = switch role {
        case .reception: ["Prendre la main sur Temi", "Appeler Hery"]
        case .housekeeping: ["Lancer le ménage", "Plus tard"]
        case .technician: ["Prendre l'intervention", "Voir le diagnostic"]
        case .it: ["Voir l'état des connecteurs", "Relancer la connexion"]
        case .manager: ["Répondre", "Partager à l'équipe"]
        }
        return titles.enumerated().map { i, t in UNNotificationAction(identifier: "\(role.rawValue)-\(i)", title: t, options: i == 0 ? [.foreground] : []) }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .list, .sound, .badge]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        guard let raw = response.notification.request.content.userInfo["role"] as? String, let role = Role(rawValue: raw) else { return }
        let id = response.notification.request.identifier
        await MainActor.run {
            AppState.shared.switchTo(role)
            AppState.shared.markRead(id)
        }
    }
}
