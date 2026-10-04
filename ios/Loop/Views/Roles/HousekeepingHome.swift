import SwiftUI

/// Housekeeping agent: the day's progress, the stuck robot, what is left for a human, floor by floor
struct HousekeepingHome: View {
    @State private var onMyWay = false
    @State private var tasks = HKTask.today

    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    Gauge(value: 0.68) {
                        Text("Ménage")
                    } currentValueLabel: {
                        Text("68 %").font(.headline)
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(.menage)
                    .scaleEffect(1.2)
                    .frame(width: 70, height: 70)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("24 appartements prêts sur 35").font(.headline)
                        Text("Fin estimée 13 h 40 · 6 robots en ménage").font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 6)
            }

            Section {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: onMyWay ? "figure.walk" : "exclamationmark.triangle.fill").font(.title2)
                        VStack(alignment: .leading, spacing: 2) {
                            HStack { Text("CLN-91C5 bloqué").font(.headline); FloorTag(text: "É3"); Text("307").font(.caption.weight(.bold)) }
                            Text(onMyWay ? "Vous êtes en route. Le robot reprend dès que la valise est posée sur le lit." : "Une valise au sol au milieu de l'app. 307, il attend depuis 18 min.")
                                .font(.subheadline).opacity(0.9)
                        }
                    }
                    Button(onMyWay ? "C'est réglé" : "J'y vais") {
                        withAnimation { onMyWay.toggle() }
                    }
                    .buttonStyle(.glass)
                    .font(.subheadline.weight(.semibold))
                }
                .foregroundStyle(.white)
                .padding(.vertical, 6)
                .listRowBackground(onMyWay ? Color.menage : Color.redLoop)
            }

            Section("À faire par moi") {
                ForEach($tasks) { $task in
                    Button {
                        withAnimation { task.done.toggle() }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: task.done ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(task.done ? Color.greenLoop : .secondary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(task.title).strikethrough(task.done).foregroundStyle(task.done ? .secondary : .primary)
                                Text(task.detail).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            FloorTag(text: task.floor)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Étages") {
                ForEach(HKFloor.all) { f in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            FloorTag(text: f.label)
                            Text(f.robot).font(.subheadline.weight(.medium))
                            Spacer()
                            Pill(text: f.state, level: f.level)
                        }
                        HStack {
                            Meter(value: f.progress, color: f.level == .alert ? .redLoop : .menage)
                            Text("\(Int(f.progress * 100)) %").font(.caption.monospacedDigit()).foregroundStyle(.secondary).frame(width: 40, alignment: .trailing)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }
}

struct HKTask: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let floor: String
    var done = false

    static let today: [HKTask] = [
        .init(title: "Poser la valise sur le lit", detail: "App. 307 · débloque CLN-91C5", floor: "É3"),
        .init(title: "Faire la 402 à la main", detail: "Client présent, ne veut pas du robot", floor: "É4"),
        .init(title: "Contrôle qualité de l'É2", detail: "7 appartements terminés par CLN-2D84", floor: "É2"),
        .init(title: "Linge propre à la laverie", detail: "2 chariots à monter avant 14 h", floor: "RDC", done: true),
    ]
}

struct HKFloor: Identifiable {
    var id: String { label }
    let label: String
    let robot: String
    let state: String
    let level: Level
    let progress: Double

    static let all: [HKFloor] = [
        .init(label: "É5", robot: "CLN-C6F2", state: "En ménage", level: .info, progress: 0.22),
        .init(label: "É4", robot: "CLN-5E07", state: "En ménage", level: .info, progress: 0.55),
        .init(label: "É3", robot: "CLN-91C5", state: "Bloqué", level: .alert, progress: 0.86),
        .init(label: "É2", robot: "CLN-2D84", state: "En ménage", level: .info, progress: 0.86),
        .init(label: "É1", robot: "CLN-7B19", state: "En ménage", level: .info, progress: 0.64),
        .init(label: "RDC", robot: "CLN-0A3E", state: "En charge", level: .ok, progress: 1),
    ]
}

#Preview {
    NavigationStack { HousekeepingHome().navigationTitle("Entretien") }
}
