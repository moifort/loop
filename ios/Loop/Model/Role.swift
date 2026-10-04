import SwiftUI

/// The people who use the companion app on site. Each role gets its own home screen and its own notifications.
enum Role: String, CaseIterable, Identifiable {
    case reception, housekeeping, technician, it, manager

    var id: String { rawValue }

    var title: String {
        switch self {
        case .reception: "Accueil"
        case .housekeeping: "Entretien"
        case .technician: "Technique"
        case .it: "IT"
        case .manager: "Direction"
        }
    }

    /// Job title shown in the role picker
    var label: String {
        switch self {
        case .reception: "Agent d'accueil et sécurité"
        case .housekeeping: "Agent d'entretien"
        case .technician: "Technicien"
        case .it: "IT"
        case .manager: "Manager"
        }
    }

    var person: String {
        switch self {
        case .reception: "Sarah Petit"
        case .housekeeping: "Inès Moreau"
        case .technician: "Karim Benali"
        case .it: "Thomas Leroy"
        case .manager: "Michael Durand"
        }
    }

    var initials: String {
        person.split(separator: " ").compactMap(\.first).map(String.init).joined()
    }

    var symbol: String {
        switch self {
        case .reception: "person.badge.shield.checkmark"
        case .housekeeping: "bubbles.and.sparkles"
        case .technician: "wrench.and.screwdriver"
        case .it: "point.3.connected.trianglepath.dotted"
        case .manager: "chart.bar.xaxis"
        }
    }

    var color: Color {
        switch self {
        case .reception: .accueil
        case .housekeeping: .menage
        case .technician: .amberLoop
        case .it: .bagages
        case .manager: .blueLoop
        }
    }
}
