import Foundation

/// A notification sent by the platform to one role
struct LoopNotification: Identifiable, Hashable {
    let id: String
    let role: Role
    let title: String
    let body: String
    let time: String
    let level: Level
    let symbol: String
    var read = false

    static func == (lhs: LoopNotification, rhs: LoopNotification) -> Bool { lhs.id == rhs.id && lhs.read == rhs.read }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension Role {
    /// What already came in today, newest first
    var history: [LoopNotification] {
        switch self {
        case .reception: [
            .init(id: "rec-1", role: self, title: "Mouvement au 5ᵉ", body: "Devant la suite 503 inoccupée · CAM-É5 couloir", time: "02:11", level: .alert, symbol: "video.badge.waveform"),
            .init(id: "rec-2", role: self, title: "Un client attend un humain", body: "Demande de facture au nom de sa société · TEMI-4F2A au comptoir", time: "09:42", level: .warn, symbol: "person.wave.2"),
            .init(id: "rec-3", role: self, title: "Porte de service ouverte 3 min", body: "Temi est allé voir : un client sortait fumer. Alerte levée par Hery.", time: "00:47", level: .info, symbol: "door.left.hand.open", read: true),
        ]
        case .housekeeping: [
            .init(id: "hk-1", role: self, title: "CLN-91C5 est bloqué", body: "Une valise au sol dans l'app. 307, le robot attend depuis 18 min", time: "11:24", level: .alert, symbol: "exclamationmark.triangle.fill"),
            .init(id: "hk-2", role: self, title: "Départ de l'app. 204", body: "Ménage lancé automatiquement · CLN-2D84", time: "10:58", level: .info, symbol: "suitcase.rolling"),
            .init(id: "hk-3", role: self, title: "É2 terminé", body: "7 appartements prêts, contrôle qualité à faire", time: "10:12", level: .ok, symbol: "checkmark.seal.fill", read: true),
        ]
        case .technician: [
            .init(id: "tc-1", role: self, title: "CAM-É4 hors ligne", body: "Depuis 00:05 · CLN-5E07 couvre le couloir en attendant", time: "00:05", level: .alert, symbol: "video.slash.fill"),
            .init(id: "tc-2", role: self, title: "CLN-5E07 batterie 22 %", body: "Retour à la base prévu vers 15 %", time: "11:02", level: .warn, symbol: "battery.25percent"),
            .init(id: "tc-3", role: self, title: "Brosse usée sur CLN-C6F2", body: "Usure 92 % · à changer avant la prochaine tournée", time: "08:30", level: .info, symbol: "wrench.adjustable", read: true),
        ]
        case .it: [
            .init(id: "it-1", role: self, title: "Milestone XProtect dégradé", body: "Latence jusqu'à 1,9 s sur les flux vidéo", time: "11:15", level: .warn, symbol: "gauge.with.dots.needle.67percent"),
            .init(id: "it-2", role: self, title: "Commande refusée par Loop", body: "greg.cleaning.start · app. 308 occupée par M. Okafor", time: "10:40", level: .alert, symbol: "hand.raised.fill"),
            .init(id: "it-3", role: self, title: "GTB Saint-Georges à configurer", body: "Automate BACnet/IP détecté dans le local technique", time: "Hier", level: .info, symbol: "building.2", read: true),
        ]
        case .manager: [
            .init(id: "mg-1", role: self, title: "Rapport de nuit", body: "3 alertes, 0 intrusion, 2 rondes sur 5 · Saint-Georges", time: "07:00", level: .info, symbol: "moon.stars.fill"),
            .init(id: "mg-2", role: self, title: "Validation demandée", body: "Karim commande 2 brosses principales · 84 €", time: "08:35", level: .warn, symbol: "cart.fill"),
            .init(id: "mg-3", role: self, title: "Taux d'occupation", body: "86 % ce soir à Saint-Georges, +4 pts sur la semaine", time: "Hier", level: .ok, symbol: "chart.line.uptrend.xyaxis", read: true),
        ]
        }
    }

    /// The live notification the demo sends for this role
    var live: (title: String, body: String, level: Level, symbol: String) {
        switch self {
        case .reception: ("Bouton panique · RDC", "TEMI-4F2A : un client demande de l'aide au comptoir. Hery est en visio.", .alert, "light.beacon.max.fill")
        case .housekeeping: ("Départ de la suite 502", "M. Garcia a rendu sa clé · le ménage peut commencer", .info, "key.fill")
        case .technician: ("Ascenseur bloqué au 3ᵉ", "Otis signale une porte qui ne se ferme pas · personne à l'intérieur", .alert, "arrow.up.arrow.down.square.fill")
        case .it: ("GregAi ne répond plus", "Loop passe en mode dégradé : les événements sont gardés en file", .alert, "bolt.horizontal.circle.fill")
        case .manager: ("Avis client 5 étoiles", "« Accueil parfait, le robot m'a porté mes valises jusqu'à la chambre »", .ok, "star.fill")
        }
    }
}
