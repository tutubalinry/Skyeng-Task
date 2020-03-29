import AVKit
import AVFoundation

struct AudioPlayer {
    
    static func play(url: URL?) {
        guard let url = url else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
