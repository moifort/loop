import SwiftUI

/// Manager: one building at a time, key figures, approvals, last night, the team on duty
struct ManagerHome: View {
    @State private var building = "Saint-Georges"
    @State private var approvals = Approval.pending

    private let buildings = ["Saint-Georges", "Opéra", "Madeleine"]

    var body: some View {
        List {
            Section {
                Picker("Immeuble", selection: $building) {
                    ForEach(buildings, id: \.self, content: Text.init)
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }

            Section {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    kpi("Occupation", "86 %", "+4 pts sur 7 jours", .blueLoop, "bed.double.fill")
                    kpi("Ménage", "68 %", "fin 13 h 40", .menage, "bubbles.and.sparkles.fill")
                    kpi("Alertes", "3", "1 en cours", .redLoop, "light.beacon.max.fill")
                    kpi("Satisfaction", "4,7", "38 avis ce mois", .amberLoop, "star.fill")
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }

            Section("À valider") {
                ForEach(approvals) { a in
                    HStack(spacing: 12) {
                        IconBadge(symbol: a.symbol, color: .blueLoop, size: 32)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(a.title).font(.subheadline.weight(.semibold))
                            Text(a.detail).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(a.amount).font(.subheadline.monospacedDigit().weight(.semibold))
                    }
                    .swipeActions(edge: .leading) {
                        Button("Valider", systemImage: "checkmark") { withAnimation { approvals.removeAll { $0.id == a.id } } }.tint(.greenLoop)
                    }
                    .swipeActions {
                        Button("Refuser", systemImage: "xmark") { withAnimation { approvals.removeAll { $0.id == a.id } } }.tint(.redLoop)
                    }
                }
                if approvals.isEmpty {
                    Label("Tout est validé", systemImage: "checkmark.seal.fill").foregroundStyle(Color.greenLoop)
                }
            }

            Section("Cette nuit") {
                LabeledContent("Rondes", value: "2 sur 5")
                LabeledContent("Intrusions", value: "0")
                LabeledContent("Fausse alerte", value: "Rideau de la 503")
                LabeledContent("Caméra en panne", value: "CAM-É4 depuis 00:05")
            }

            Section("Équipe en poste") {
                person("Inès Moreau", "Accueil et sécurité", "IM", .accueil, "Au comptoir")
                person("Hery Rakoto", "Réception de nuit · Madagascar", "HR", .bagages, "À distance")
                person("Léa Martin", "Entretien", "LM", .menage, "É3 · app. 307")
                person("Karim Benali", "Technicien", "KB", .amberLoop, "Local technique")
            }
        }
    }

    private func kpi(_ label: String, _ value: String, _ sub: String, _ color: Color, _ symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(label, systemImage: symbol).font(.caption.weight(.semibold)).foregroundStyle(color)
            Text(value).font(.title.weight(.bold).monospacedDigit())
            Text(sub).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.background, in: .rect(cornerRadius: 18))
    }

    private func person(_ name: String, _ job: String, _ initials: String, _ color: Color, _ where_: String) -> some View {
        HStack(spacing: 12) {
            Text(initials).font(.caption.weight(.bold)).foregroundStyle(.white)
                .frame(width: 34, height: 34).background(color.gradient, in: .circle)
            VStack(alignment: .leading, spacing: 2) {
                Text(name).font(.subheadline.weight(.semibold))
                Text(job).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(where_).font(.caption).foregroundStyle(.secondary)
        }
    }
}

struct Approval: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let amount: String
    let symbol: String

    static let pending: [Approval] = [
        .init(title: "2 brosses principales", detail: "Karim · pour CLN-C6F2 et le stock", amount: "84 €", symbol: "cart.fill"),
        .init(title: "Remplacement CAM-É4", detail: "Karim · caméra de rechange + pose", amount: "320 €", symbol: "video.fill"),
        .init(title: "Heures de nuit", detail: "Hery · 4 h en plus cette semaine", amount: "4 h", symbol: "clock.fill"),
    ]
}

#Preview {
    NavigationStack { ManagerHome().navigationTitle("Direction") }
}
