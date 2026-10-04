import SwiftUI

/// Housekeeping agent: her apartments (the robot starts when she badges in), the day's progress, the stuck robot,
/// what is left for a human, floor by floor
struct HousekeepingHome: View {
    @State private var onMyWay = false
    @State private var tasks = HKTask.today
    /// Story of app. 203, as on the deck: 0 departure, 1 Inès badges in, 2 robot cleaning, 3 ready, 4 refused at 306.
    /// Tap the 203 card to move on; `-hkStep n` starts at a given step (screenshots).
    @State private var step = UserDefaults.standard.integer(forKey: "hkStep")

    var body: some View {
        List {
            Section {
                apartment203
                apartment306
            } header: {
                Text("Mes appartements · É2")
            }

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

extension HousekeepingHome {
    private var apartment203: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("App. 203").font(.headline)
                Spacer()
                switch step {
                case 0: Pill(text: "Départ 11:00", level: .warn)
                case 1: Pill(text: "Inès est là", level: .info)
                case 2: Pill(text: "En ménage", level: .info, symbol: "bubbles.and.sparkles.fill")
                default: Pill(text: "Prêt", level: .ok, symbol: "checkmark")
                }
            }
            Text(step == 0 ? "Prochaine arrivée à 16 h" : step == 1 ? "13:42 · Inès entre (badge Salto)" : step == 2 ? "CLN-2D84 fait les sols pendant que vous faites le lit" : "Prêt à 13:58 · Greg prévenu")
                .font(.subheadline).foregroundStyle(.secondary)
            if step == 2 { Meter(value: 0.46, color: .menage) }
            if step < 3 {
                Label(step == 0 ? "Démarre à l'arrivée d'Inès" : step == 1 ? "Lancement du robot…" : "Robot lancé tout seul", systemImage: "bubbles.and.sparkles.fill")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .foregroundStyle(step == 0 ? Color.secondary : .white)
                    .background(step == 0 ? Color(.tertiarySystemFill) : Color.blueLoop, in: .rect(cornerRadius: 12))
            }
        }
        .padding(.vertical, 4)
        .contentShape(.rect)
        .onTapGesture { withAnimation { step = (step + 1) % 5 } }
    }

    private var apartment306: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("App. 306").font(.headline)
                Spacer()
                Pill(text: "Occupé", level: .idle, symbol: "person.fill")
            }
            Text("M. Okafor jusqu'au 5 oct.").font(.subheadline).foregroundStyle(.secondary)
            if step == 4 {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pas de robot").font(.subheadline.weight(.bold))
                        Text("Vous entrez au 306, mais il est occupé : le robot reste à sa base.").font(.caption)
                    }
                } icon: {
                    Image(systemName: "exclamationmark.circle.fill").font(.title3)
                }
                .foregroundStyle(.white)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.amberLoop, in: .rect(cornerRadius: 12))
            } else {
                Label("Jamais de robot chez un client", systemImage: "hand.raised.fill")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .foregroundStyle(.secondary)
                    .background(Color(.tertiarySystemFill), in: .rect(cornerRadius: 12))
            }
        }
        .padding(.vertical, 4)
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
