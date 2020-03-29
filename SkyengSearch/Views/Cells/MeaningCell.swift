import UIKit

class MeaningCell: UITableViewCell {
    
    private let translationLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let transcriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageButton: URLImageButton = {
        let view = URLImageButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let soundButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "play"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private var meaning: Meaning?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        soundButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        imageButton.addTarget(self, action: #selector(showImage), for: .touchUpInside)
    
        [translationLabel, transcriptionLabel, imageButton, soundButton].forEach(contentView.addSubview)
        
        translationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        translationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        transcriptionLabel.topAnchor.constraint(equalTo: translationLabel.bottomAnchor, constant: 16).isActive = true
        transcriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        transcriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        soundButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        soundButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        soundButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        soundButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        imageButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageButton.trailingAnchor.constraint(equalTo: soundButton.leadingAnchor, constant: -16).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    func setup(meaning: Meaning) {
        self.meaning = meaning
        
        translationLabel.text = meaning.translationText
        transcriptionLabel.text = "[\(meaning.transcription)]"
        
        imageButton.setup(url: meaning.previewURL)
    }
    
    @objc private func play() {
        AudioPlayer.play(url: meaning?.soundURL)
    }
    
    @objc private func showImage() {
        ImageViewer.show(url: meaning?.imageURL)
    }
}
