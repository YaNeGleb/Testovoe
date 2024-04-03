import UIKit
import SDWebImage
import WebKit

class DetailPostViewController: UIViewController {

    private var viewModel: DetailPostViewModelProtocol
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let publishedDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let goToWebsiteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go to Website", for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.orange.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    init(viewModel: DetailPostViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        configureNavBar()
        configureTitleLabel()
        configureImageView()
        configureDescriptionLabel()
        configureButton()
    }
    
    private func configureNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        let activityIndicatorItem = UIBarButtonItem(customView: publishedDateLabel)
        navigationItem.rightBarButtonItem = activityIndicatorItem
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
        ])
    }
    
    private func configureDescriptionLabel() {
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureWebView() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureButton() {
        view.addSubview(goToWebsiteButton)
        NSLayoutConstraint.activate([
            goToWebsiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            goToWebsiteButton.widthAnchor.constraint(equalToConstant: 130),
            goToWebsiteButton.heightAnchor.constraint(equalToConstant: 45),
            goToWebsiteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        goToWebsiteButton.addTarget(self, action: #selector(goToWebsite), for: .touchUpInside)
    }
    
    @objc private func goToWebsite() {
        configureWebView()
        let postURLString = viewModel.post.url
        guard let url = URL(string: postURLString) else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func setupUI() {
        let post = viewModel.post
        titleLabel.text = post.title
        publishedDateLabel.text = post.publishedDate
        descriptionLabel.text = post.abstract
        if let firstMedia = post.media.last {
            let firstImage = firstMedia.mediaMetadata.last?.url ?? ""
            imageView.sd_setImage(with: URL(string: firstImage))
        }
    }
}
