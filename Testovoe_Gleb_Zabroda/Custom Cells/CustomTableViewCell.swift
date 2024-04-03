import UIKit
import SDWebImage

protocol CustomCellDelegate: AnyObject {
    func didLongPressOnCell(_ cell: CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CustomTableViewCell"
    weak var delegate: CustomCellDelegate?
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 3
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let publishedDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "bookmark.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .orange
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .black
        contentView.addSubview(titleLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(favoriteIndicator)
        contentView.addSubview(publishedDateLabel)
        
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postImageView.widthAnchor.constraint(equalToConstant: 80),
            postImageView.heightAnchor.constraint(equalToConstant: 90),
            
            favoriteIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            favoriteIndicator.widthAnchor.constraint(equalToConstant: 20),
            favoriteIndicator.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteIndicator.leadingAnchor, constant: -8),
            
            sourceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            sourceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sourceLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            sourceLabel.heightAnchor.constraint(equalToConstant: 15),
            
            publishedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            publishedDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            publishedDateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            publishedDateLabel.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
    
    func setupInfo(post: Post?, isFavorite: Bool) {
        guard let post else { return }
        titleLabel.text = post.title
        favoriteIndicator.isHidden = !isFavorite
        sourceLabel.text = post.source.rawValue
        publishedDateLabel.text = post.publishedDate
        if let firstMedia = post.media.last {
            let firstImage = firstMedia.mediaMetadata.last?.url ?? "No URL available"
            postImageView.sd_setImage(with: URL(string: firstImage))
        }
    }
    
    private func addGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        contentView.addGestureRecognizer(longPressGesture)
        contentView.isUserInteractionEnabled = true
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        delegate?.didLongPressOnCell(self)
    }
}
