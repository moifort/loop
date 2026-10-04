import SwiftUI

/// Technician: urgent fault, work orders on robots and equipment, spare parts
struct TechnicianHome: View {
    @State private var taken = false
    @State private var orders = WorkOrder.open

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    CameraTile(camera: .floor4, height: 130)
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("CAM-É4 hors ligne").font(.headline)
                            Text("Coupée à 00:05, ne répond plus au ping. CLN-5E07 couvre le couloir en attendant.")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    Button {
                        withAnimation { taken.toggle() }
                    } label: {
                        Label(taken ? "Intervention prise · en route" : "Prendre l'intervention", systemImage: taken ? "checkmark" : "hand.raised.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(taken ? .greenLoop : .redLoop)
                }
                .padding(.vertical, 4)
            } header: {
                Text("Urgent")
            }

            Section("Interventions") {
                ForEach(orders) { o in
                    HStack(spacing: 12) {
                        IconBadge(symbol: o.symbol, color: o.level.color)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(o.title).font(.subheadline.weight(.semibold))
                            Text(o.detail).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            FloorTag(text: o.floor)
                            Text(o.due).font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                    .swipeActions {
                        Button("Terminé", systemImage: "checkmark") { withAnimation { orders.removeAll { $0.id == o.id } } }.tint(.greenLoop)
                    }
                }
            }

            Section("Pièces en stock") {
                LabeledContent("Brosses principales") { Pill(text: "2 · commande en attente", level: .warn) }
                LabeledContent("Filtres HEPA") { Pill(text: "6", level: .ok) }
                LabeledContent("Batteries robots") { Pill(text: "1", level: .warn) }
                LabeledContent("Caméras de rechange") { Pill(text: "1", level: .ok) }
            }
        }
    }
}

struct WorkOrder: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let floor: String
    let due: String
    let level: Level
    let symbol: String

    static let open: [WorkOrder] = [
        .init(title: "CLN-5E07 batterie 22 %", detail: "Recharge forcée ou remplacement de la batterie", floor: "É4", due: "Aujourd'hui", level: .warn, symbol: "battery.25percent"),
        .init(title: "Brosse usée sur CLN-C6F2", detail: "Usure 92 % · pièce en stock", floor: "É5", due: "Avant 18 h", level: .warn, symbol: "wrench.adjustable"),
        .init(title: "Révision Otis", detail: "Visite annuelle avec le technicien Otis", floor: "RDC", due: "14 oct.", level: .info, symbol: "arrow.up.arrow.down.square"),
        .init(title: "Sonde CO₂ de l'É2", detail: "Valeurs figées depuis hier dans la GTB", floor: "É2", due: "Cette semaine", level: .info, symbol: "aqi.medium"),
    ]
}

#Preview {
    NavigationStack { TechnicianHome().navigationTitle("Technique") }
}
