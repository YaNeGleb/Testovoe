import UIKit

class FavoriteDetailViewController: UIViewController {
    
    let viewModel: FavoriteDetailViewModelProtocol
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private let releaseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    init(viewModel: FavoriteDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInfo()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(separatorView)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(releaseLabel)
        scrollView.addSubview(sourceLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            separatorView.heightAnchor.constraint(equalToConstant: 3),
            
            descriptionLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            releaseLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            releaseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            releaseLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            sourceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            sourceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sourceLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)

        ])
    }
    
    private func setupInfo() {
        let post = viewModel.post
        titleLabel.text = post.title
        descriptionLabel.text = post.abstract
        releaseLabel.text = post.publishedDate
        sourceLabel.text = post.source
    }
}
