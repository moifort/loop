import SwiftUI

/// IT: GregAi link, connectors (pausing one switches the platform to degraded mode), latest incidents
struct ITHome: View {
    @State private var connectors = Connector.all

    private var paused: [Connector] { connectors.filter { $0.state == .paused } }

    var body: some View {
        List {
            if !paused.isEmpty {
                Section {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Mode dégradé").font(.headline)
                            Text("\(paused.map(\.name).joined(separator: ", ")) en pause : les robots continuent seuls, les événements sont gardés en file.")
                                .font(.subheadline).opacity(0.9)
                        }
                    } icon: {
                        Image(systemName: "pause.circle.fill").font(.title2)
                    }
                    .foregroundStyle(Color(hex: 0x2B1A00))
                    .padding(.vertical, 4)
                    .listRowBackground(Color.amberLoop)
                }
            }

            Section {
                HStack(spacing: 0) {
                    stat("Envoyés", "249")
                    Divider()
                    stat("Latence", "180 ms")
                    Divider()
                    stat("Dispo.", "98,7 %")
                }
                .padding(.vertical, 4)
            } header: {
                Text("GregAi · aujourd'hui")
            }

            Section("Connecteurs") {
                ForEach($connectors) { $c in
                    HStack(spacing: 12) {
                        Text(c.mono)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(c.color.gradient, in: .rect(cornerRadius: 9))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(c.name).font(.subheadline.weight(.semibold))
                            Text(c.detail).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Pill(text: c.state.label, level: c.state.level)
                    }
                    .swipeActions {
                        if c.state == .paused {
                            Button("Reprendre", systemImage: "play.fill") { withAnimation { c.state = .ok } }.tint(.greenLoop)
                        } else if c.state != .setup {
                            Button("Pause", systemImage: "pause.fill") { withAnimation { c.state = .paused } }.tint(.amberLoop)
                        }
                    }
                }
            }

            Section("Incidents") {
                incident("Commande refusée", "greg.cleaning.start · app. 308 occupée par M. Okafor", "10:40", .alert, "hand.raised.fill")
                incident("Synchro dégradée 16 min", "Le PMS répondait lentement à Greg · aucun événement perdu", "08:12", .warn, "gauge.with.dots.needle.33percent")
                incident("Coupure GregAi 22 s", "3 événements gardés en file puis rejoués dans l'ordre", "Hier", .info, "arrow.clockwise")
            }
        }
    }

    private func stat(_ label: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.headline.monospacedDigit())
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func incident(_ title: String, _ detail: String, _ time: String, _ level: Level, _ symbol: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            IconBadge(symbol: symbol, color: level.color, size: 30)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(time).font(.caption).foregroundStyle(.secondary)
        }
    }
}

struct Connector: Identifiable {
    enum State {
        case ok, warn, paused, setup

        var label: String {
            switch self {
            case .ok: "Connecté"
            case .warn: "Dégradé"
            case .paused: "En pause"
            case .setup: "À configurer"
            }
        }

        var level: Level {
            switch self {
            case .ok: .ok
            case .warn: .warn
            case .paused: .idle
            case .setup: .info
            }
        }
    }

    var id: String { name }
    let name: String
    let detail: String
    let mono: String
    let color: Color
    var state: State

    static let all: [Connector] = [
        .init(name: "GregAi", detail: "IA · tous les immeubles", mono: "G", color: .accueil, state: .ok),
        .init(name: "Mews", detail: "PMS · tous les immeubles", mono: "M", color: .black, state: .ok),
        .init(name: "Salto KS", detail: "Serrures · tous les immeubles", mono: "S", color: .redLoop, state: .ok),
        .init(name: "WhatsApp Business", detail: "Messagerie de l'équipe", mono: "W", color: .greenLoop, state: .ok),
        .init(name: "Milestone XProtect", detail: "Caméras · latence 1,9 s", mono: "X", color: Color(hex: 0x1E40AF), state: .warn),
        .init(name: "Otis Integrated", detail: "Ascenseurs · Saint-Georges, Opéra", mono: "O", color: Color(hex: 0x1E3A8A), state: .ok),
        .init(name: "GTB Saint-Georges", detail: "Bâtiment · BACnet/IP", mono: "B", color: .grayLoop, state: .setup),
    ]
}

#Preview {
    NavigationStack { ITHome().navigationTitle("IT") }
}
