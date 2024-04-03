import UIKit

class MessageView: UIView {
    
    private var message: String
    private var borderColor: UIColor
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(message: String, borderColor: UIColor) {
        self.message = message
        self.borderColor = borderColor
        super.init(frame: .zero)
        self.setUpUI()
        self.setupInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        backgroundColor = .black
        layer.cornerRadius = 16
        layer.borderWidth = 1.0
        layer.borderColor = borderColor.cgColor
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setupInfo() {
        messageLabel.text = message
    }
}
