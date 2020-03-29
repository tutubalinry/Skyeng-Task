import UIKit

struct ImageViewer {
    
    static func show(url: URL?) {
        guard let url = url else { return }
        
        DispatchQueue.main.async {
            let view = UIImageView(image: nil)
            view.backgroundColor = .clear
            view.contentMode = .scaleAspectFit
            view.isUserInteractionEnabled = true
            view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .blue
            indicator.startAnimating()
            indicator.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(indicator)
            
            let tapRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIImageView.removeFromSuperview))
            view.addGestureRecognizer(tapRecognizer)
            
            UIApplication.shared.topWindow?.addSubview(view)
            
            guard let window = UIApplication.shared.topWindow else { return }
            
            window.addSubview(view)
            
            view.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            
            indicator.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            indicator.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            
            DispatchQueue(label: "com.applicationtest.test.image_download").async {
                let request = URLRequest(url: url)
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            view.image = image
                            
                            indicator.removeFromSuperview()
                        }
                    }
                }
                .resume()
            }
        }
    }
    
}
