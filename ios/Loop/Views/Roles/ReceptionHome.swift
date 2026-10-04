import SwiftUI

/// Reception agent, with the security features: live alert, greeter robot, cameras, luggage cart, panic button
struct ReceptionHome: View {
    @State private var alert: AlertState = .open
    /// `-remote YES` opens the screen already taken over, with the guest's card (screenshots)
    @State private var remote = UserDefaults.standard.bool(forKey: "remote")
    @State private var confirmPanic = false
    @State private var panic = false
    @State private var camera: Camera?

    enum AlertState { case open, checking, resolved }

    var body: some View {
        List {
            if alert != .resolved { alertSection }
            if remote { guestSection }

            Section("Robot d'accueil") {
                VStack(alignment: .leading, spacing: 12) {
                    ZStack(alignment: .bottomLeading) {
                        CameraTile(camera: .temi, height: 180)
                        if remote {
                            Label("Vous parlez par Temi", systemImage: "mic.fill")
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(.green, in: .capsule)
                                .foregroundStyle(.white)
                                .padding(10)
                        }
                    }
                    HStack {
                        IconBadge(symbol: "figure.wave", color: .accueil)
                        VStack(alignment: .leading) {
                            Text("TEMI-4F2A").font(.headline)
                            Text("Comptoir d'accueil · 23 visiteurs aujourd'hui").font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Pill(text: remote ? "Contrôlé" : "En service", level: remote ? .ok : .info)
                    }
                    if !remote {
                        Label("Un client attend un humain depuis 3 min", systemImage: "person.wave.2.fill")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Color(hex: 0x9A5B00))
                    }
                    Button {
                        withAnimation { remote.toggle() }
                    } label: {
                        Label(remote ? "Rendre la main au robot" : "Prendre la main", systemImage: remote ? "video.slash.fill" : "video.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(remote ? .redLoop : .greenLoop)
                }
                .padding(.vertical, 4)
            }

            Section {
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(Camera.wall) { cam in
                            Button { camera = cam } label: {
                                CameraTile(camera: cam, motion: cam == .floor5 && alert == .open, height: 110)
                                    .frame(width: 190)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            } header: {
                HStack { Text("Caméras"); Spacer(); Text("8/9 en ligne").textCase(nil) }
            }

            Section("Bagages") {
                HStack(spacing: 12) {
                    IconBadge(symbol: "suitcase.rolling.fill", color: .bagages)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("KILO-3B8D").font(.headline)
                        Text("Avec M. Bernard vers l'app. 204 · 2 valises").font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    FloorTag(text: "É2")
                }
                LabeledContent("Prochaine arrivée", value: "Mme Okafor · 14:30")
            }

            Section {
                Button {
                    if panic { withAnimation { panic = false } } else { confirmPanic = true }
                } label: {
                    Label(panic ? "Lever l'alerte panique" : "Bouton panique", systemImage: "light.beacon.max.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 36)
                }
                .buttonStyle(.glassProminent)
                .tint(panic ? .grayLoop : .redLoop)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            } footer: {
                Text(panic ? "Hery (Madagascar) et l'équipe sur place sont prévenus. Les caméras du RDC enregistrent." : "Prévient Hery, l'équipe sur place et la sécurité. Les caméras du RDC enregistrent.")
            }
        }
        .navigationDestination(item: $camera) { cam in CameraDetail(camera: cam, motion: cam == .floor5 && alert == .open) }
        .confirmationDialog("Déclencher l'alerte panique ?", isPresented: $confirmPanic, titleVisibility: .visible) {
            Button("Déclencher", role: .destructive) { withAnimation { panic = true } }
        }
        .sensoryFeedback(.warning, trigger: panic)
    }

    /// The guest at the counter, found by Greg in Mews while you speak through Temi (same card as the web platform)
    private var guestSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Text("CL").font(.subheadline.weight(.bold)).foregroundStyle(.white)
                        .frame(width: 40, height: 40).background(Color.accueil.gradient, in: .circle)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Mme Claire Lefèvre").font(.headline)
                        Text("Atelier Nord SAS · cliente depuis 2024").font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Pill(text: "En visio", level: .info, symbol: "video.fill")
                }
                (Text("Demande en cours : ").bold() + Text("facture au nom de sa société pour son séjour en cours."))
                    .font(.subheadline)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.amberLoop.opacity(0.14), in: .rect(cornerRadius: 10))
                guestRow("Réservation", "App. 305 · 3 nuits", "du 2 au 5 oct. · arrivée 15 h 20")
                guestRow("Société", "Atelier Nord SAS", "SIRET 812 345 678 00021")
                guestRow("Contact", "c.lefevre@ateliernord.fr", "+33 6 12 34 56 78 · français")
                guestRow("Séjours", "4ᵉ séjour", "dernier en juin 2026, app. 402")
                HStack {
                    Button("Envoyer la facture", systemImage: "checkmark") {}.buttonStyle(.glassProminent)
                    Button("Réservation", systemImage: "arrow.right") {}.buttonStyle(.glass)
                }
                .font(.subheadline.weight(.semibold))
            }
            .padding(.vertical, 4)
        } header: {
            Text("Fiche client · retrouvée par Greg dans Mews")
        }
    }

    private func guestRow(_ label: String, _ value: String, _ detail: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label).font(.subheadline).foregroundStyle(.secondary)
            Spacer()
            VStack(alignment: .trailing, spacing: 1) {
                Text(value).font(.subheadline.weight(.semibold))
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
        }
    }

    private var alertSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: alert == .checking ? "figure.walk.motion" : "light.beacon.max.fill")
                        .font(.title2)
                        .symbolEffect(.pulse, isActive: alert == .open)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(alert == .checking ? "CLN-C6F2 va vérifier" : "Mouvement au 5ᵉ").font(.headline)
                        Text(alert == .checking ? "Il filme le couloir de l'É5 en arrivant devant la 503." : "Devant la suite 503, inoccupée. CAM-É5 couloir · 02:11.")
                            .font(.subheadline).opacity(0.9)
                    }
                }
                HStack {
                    if alert == .open {
                        Button("Envoyer CLN-C6F2") { withAnimation { alert = .checking } }
                            .buttonStyle(.glass)
                    } else {
                        Button("Fausse alerte : rideau") { withAnimation { alert = .resolved } }
                            .buttonStyle(.glass)
                    }
                    Button("Voir la caméra") { camera = .floor5 }
                        .buttonStyle(.glass)
                }
                .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .padding(.vertical, 6)
            .listRowBackground(alert == .checking ? Color.bagages : Color.redLoop)
        }
    }
}

#Preview {
    NavigationStack { ReceptionHome().navigationTitle("Accueil") }
}
