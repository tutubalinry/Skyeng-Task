import UIKit

class URLImageButton: UIButton {
    
    private let urlImageView: UIImageView = {
        let view = UIImageView(image: nil)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = UIColor.black.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        urlImageView.layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
    private func setupViews() {
        [urlImageView, activityIndicator].forEach(addSubview)
        
        urlImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        urlImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        urlImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        urlImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func setup(url: URL?) {
        guard let url = url else { return }
        
        activityIndicator.startAnimating()
        
        DispatchQueue(label: "com.applicationtest.test.urlButtonDownload").async {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.urlImageView.image = image
                    }
                }
            }
            .resume()
        }
    }
    
}
