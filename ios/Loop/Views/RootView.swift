import SwiftUI

/// One home screen per role. The role menu (top left) switches role for the demo, the bell opens the notifications.
struct RootView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        NavigationStack {
            home
                .navigationTitle(state.role.title)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) { roleMenu }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { state.showInbox = true } label: {
                            Image(systemName: state.unread > 0 ? "bell.badge.fill" : "bell")
                                .symbolRenderingMode(.multicolor)
                        }
                        .badge(state.unread)
                        .accessibilityLabel("Notifications, \(state.unread) non lues")
                    }
                }
        }
        .sheet(isPresented: Binding(get: { state.showInbox }, set: { state.showInbox = $0 })) { NotificationsView() }
        .task {
            if UserDefaults.standard.bool(forKey: "notify") { state.sendLive(after: 2) }
        }
        .tint(.blueLoop)
    }

    @ViewBuilder private var home: some View {
        switch state.role {
        case .reception: ReceptionHome()
        case .housekeeping: HousekeepingHome()
        case .technician: TechnicianHome()
        case .it: ITHome()
        case .manager: ManagerHome()
        }
    }

    private var roleMenu: some View {
        Menu {
            Section("Changer de rôle (démo)") {
                ForEach(Role.allCases) { role in
                    Button {
                        withAnimation { state.switchTo(role) }
                    } label: {
                        Label("\(role.label) · \(role.person)", systemImage: role.symbol)
                    }
                }
            }
        } label: {
            Text(state.role.initials)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(state.role.color.gradient, in: .circle)
        }
        .accessibilityLabel("Rôle : \(state.role.label)")
    }
}

#Preview {
    RootView().environment(AppState.shared)
}
