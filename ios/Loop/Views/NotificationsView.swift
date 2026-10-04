import SwiftUI

/// The role's notifications, newest first, with a button that sends a real iOS notification for the demo
struct NotificationsView: View {
    @Environment(AppState.self) private var state
    @Environment(\.dismiss) private var dismiss
    @State private var sent = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        state.sendLive()
                        sent = true
                        Task { try? await Task.sleep(for: .seconds(4)); sent = false }
                    } label: {
                        Label(sent ? "Arrive dans 3 s… verrouillez l'iPhone pour la voir" : "Simuler une notification", systemImage: sent ? "hourglass" : "paperplane.fill")
                    }
                    .disabled(sent)
                } footer: {
                    Text("Envoie la notification « \(state.role.live.title) » comme le ferait la plateforme.")
                }

                Section("Aujourd'hui") {
                    ForEach(state.notifications) { n in
                        NotificationRow(notification: n)
                            .swipeActions { Button("Lu") { state.markRead(n.id) }.tint(.blueLoop) }
                            .onTapGesture { state.markRead(n.id) }
                    }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Tout lire") { state.markAllRead() }.disabled(state.unread == 0)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .close) { dismiss() }
                }
            }
            .animation(.default, value: state.notifications)
        }
    }
}

struct NotificationRow: View {
    let notification: LoopNotification

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            IconBadge(symbol: notification.symbol, color: notification.level.color, size: 36)
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(notification.title).font(.subheadline.weight(notification.read ? .regular : .semibold))
                    Spacer()
                    Text(notification.time).font(.caption).foregroundStyle(.secondary).monospacedDigit()
                }
                Text(notification.body).font(.footnote).foregroundStyle(.secondary)
            }
            if !notification.read {
                Circle().fill(Color.blueLoop).frame(width: 8, height: 8).padding(.top, 6)
            }
        }
        .padding(.vertical, 2)
        .contentShape(.rect)
    }
}
