import SwiftUI

// Loop palette, the same as the web platform
extension Color {
    init(hex: UInt32) {
        self.init(red: Double((hex >> 16) & 0xFF) / 255, green: Double((hex >> 8) & 0xFF) / 255, blue: Double(hex & 0xFF) / 255)
    }

    static let blueLoop = Color(hex: 0x006FFF)
    static let greenLoop = Color(hex: 0x22A861)
    static let amberLoop = Color(hex: 0xF0A020)
    static let redLoop = Color(hex: 0xE5484D)
    static let grayLoop = Color(hex: 0xA0A7B0)
    static let accueil = Color(hex: 0x1E3A8A)
    static let menage = Color(hex: 0x0EA5E9)
    static let bagages = Color(hex: 0x7C3AED)
}

/// Severity shared by pills, notifications and alerts
enum Level {
    case ok, info, warn, alert, idle

    var color: Color {
        switch self {
        case .ok: .greenLoop
        case .info: .blueLoop
        case .warn: .amberLoop
        case .alert: .redLoop
        case .idle: .grayLoop
        }
    }
}

/// Small rounded status label, as on the web platform
struct Pill: View {
    let text: String
    var level: Level = .ok
    var symbol: String?

    var body: some View {
        HStack(spacing: 4) {
            if let symbol { Image(systemName: symbol).font(.caption2.weight(.bold)) }
            Text(text)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(level == .warn ? Color(hex: 0x9A5B00) : level.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(level.color.opacity(0.14), in: .capsule)
    }
}

/// Round icon in a tinted disc, used at the start of rows
struct IconBadge: View {
    let symbol: String
    var color: Color
    var size: CGFloat = 34

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: size * 0.45, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(color.gradient, in: .rect(cornerRadius: size * 0.28))
    }
}

/// Thin progress bar
struct Meter: View {
    let value: Double
    var color: Color = .menage

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(color.opacity(0.15))
                Capsule().fill(color).frame(width: geo.size.width * min(max(value, 0), 1))
            }
        }
        .frame(height: 6)
    }
}

/// Floor tag (É5, RDC…)
struct FloorTag: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color(hex: 0x3A4150), in: .rect(cornerRadius: 4))
    }
}
