import AVFoundation
import SwiftUI

/// Camera of the building. Feeds are fixed-shot looping Pexels clips (free licence), the same as the web platform.
struct Camera: Identifiable, Hashable {
    let id: String
    let name: String
    let floor: String
    var feed: URL?
    var offSince: String?

    static let hall = Camera(id: "CAM-HALL", name: "Hall · entrée", floor: "RDC", feed: pexels("38469386/16337290_960_540_25fps"))
    static let reception = Camera(id: "CAM-REC", name: "Réception", floor: "RDC", feed: pexels("36219791/15359774_960_540_50fps"))
    static let serviceDoor = Camera(id: "CAM-SERV", name: "Porte de service", floor: "RDC", feed: pexels("35130882/14882355_960_540_50fps"))
    static let floor5 = Camera(id: "CAM-É5", name: "Couloir É5", floor: "É5", feed: pexels("10577855/10577855-sd_960_540_30fps"))
    static let floor4 = Camera(id: "CAM-É4", name: "Couloir É4", floor: "É4", offSince: "00:05")
    static let temi = Camera(id: "TEMI-4F2A", name: "Caméra de Temi · comptoir", floor: "RDC", feed: pexels("6997941/6997941-hd_1280_720_25fps"))

    static let wall: [Camera] = [floor5, hall, reception, serviceDoor, floor4]

    private static func pexels(_ path: String) -> URL? { URL(string: "https://videos.pexels.com/video-files/\(path).mp4") }
}

/// Muted video that loops forever, filling its frame
struct LoopingVideo: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.play(url)
        return view
    }

    func updateUIView(_ view: PlayerView, context: Context) {}

    final class PlayerView: UIView {
        override class var layerClass: AnyClass { AVPlayerLayer.self }
        private var looper: AVPlayerLooper?

        func play(_ url: URL) {
            let player = AVQueuePlayer()
            player.isMuted = true
            looper = AVPlayerLooper(player: player, templateItem: AVPlayerItem(url: url))
            let layer = layer as! AVPlayerLayer
            layer.player = player
            layer.videoGravity = .resizeAspectFill
            player.play()
        }
    }
}

/// Camera tile: live footage with the camera ID, the clock and its state; an offline camera reads as a problem
struct CameraTile: View {
    let camera: Camera
    var motion = false
    var height: CGFloat = 120

    var body: some View {
        ZStack {
            if let feed = camera.feed {
                Color.black
                LoopingVideo(url: feed)
            } else {
                RadialGradient(colors: [Color(hex: 0x3A1418), Color(hex: 0x170B0E)], center: .center, startRadius: 0, endRadius: 160)
                VStack(spacing: 4) {
                    Image(systemName: "video.slash").font(.title2).foregroundStyle(Color(hex: 0xFF6B70))
                    Text("Flux interrompu").font(.caption.weight(.semibold)).foregroundStyle(Color(hex: 0xFF8A8E))
                    if let since = camera.offSince { Text("coupé à \(since)").font(.caption2).foregroundStyle(Color(hex: 0xE3B5B8)) }
                }
            }
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(camera.id).font(.caption.weight(.bold))
                        Text(camera.name).font(.caption2).opacity(0.85)
                    }
                    Spacer()
                    if camera.feed != nil {
                        TimelineView(.everyMinute) { ctx in
                            HStack(spacing: 4) {
                                Circle().fill(Color.redLoop).frame(width: 6, height: 6)
                                Text(ctx.date, format: .dateTime.hour().minute()).font(.caption2.monospacedDigit().weight(.semibold))
                            }
                        }
                    }
                }
                Spacer()
                HStack {
                    if camera.feed == nil {
                        Pill(text: "Hors ligne", level: .alert).background(.white, in: .capsule)
                    } else if motion {
                        Pill(text: "Mouvement", level: .alert).background(.white, in: .capsule)
                    }
                    Spacer()
                }
            }
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.7), radius: 2)
            .padding(8)
        }
        .frame(height: height)
        .clipShape(.rect(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14).strokeBorder(camera.feed == nil || motion ? Color.redLoop : .clear, lineWidth: 2)
        }
    }
}

/// Full-screen camera with its actions
struct CameraDetail: View {
    let camera: Camera
    var motion = false

    var body: some View {
        List {
            Section {
                CameraTile(camera: camera, motion: motion, height: 220)
                    .listRowInsets(EdgeInsets())
            }
            Section {
                LabeledContent("Étage", value: camera.floor)
                LabeledContent("Enregistrement", value: "30 jours, en France")
                if motion { LabeledContent("Détection", value: "02:11 · devant la suite 503") }
            }
            if motion {
                Section {
                    Button("Envoyer CLN-C6F2 vérifier", systemImage: "bubbles.and.sparkles") {}
                    Button("Lever l'alerte", systemImage: "checkmark.shield", role: .destructive) {}
                }
            }
        }
        .navigationTitle(camera.id)
        .navigationBarTitleDisplayMode(.inline)
    }
}
