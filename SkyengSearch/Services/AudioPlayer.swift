import AVKit
import AVFoundation

struct AudioPlayer {
    
    static func play(url: URL?) {
        guard let oldURL = url, let url = URL(string: "https:\(oldURL.absoluteString)") else { return }
        
        DispatchQueue.main.async {
            let player = try? AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = 1.0
            player?.play()
        }
    }
    
}
