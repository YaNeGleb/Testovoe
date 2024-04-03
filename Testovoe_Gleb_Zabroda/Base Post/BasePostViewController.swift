import UIKit

class BasePostViewController: UIViewController {
    
    var baseViewModel: BasePostsViewModelProtocol
    
    private var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CustomTableViewCell.self,
                           forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier)
        tableView.separatorColor = UIColor.lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = .black
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    init(baseViewModel: BasePostsViewModelProtocol) {
        self.baseViewModel = baseViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
        configureUI()
    }
    
    private func observeViewModel() {
        baseViewModel.onFetchPosts = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        baseViewModel.isLoadingCompletion = { [weak self] isLoading in
            guard let self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                }
            }
        }
        
        baseViewModel.onActionWithPost = { [weak self] index in
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: index, section: 0)
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        baseViewModel.onActionWithError = { [weak self] in
            DispatchQueue.main.async {
                self?.showFailureAddFilmView()
            }
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        configureTableView()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let activityIndicatorItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = activityIndicatorItem
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func pushToDetailVC(index: Int) {
        let detailVC = baseViewModel.didSelectPost(at: index)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func setUpConstraintsForMessageView(messageView: MessageView) {
        messageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageView)
        
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            messageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func showFailureAddFilmView() {
        let failureView = MessageView(message: "An error occurred. Please try again", borderColor: .red)
        setUpConstraintsForMessageView(messageView: failureView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            failureView.removeFromSuperview()
        }
    }
}

extension BasePostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseViewModel.numberOfPosts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let post = baseViewModel.getPost(index: indexPath.row)
        let isFavoritePost = baseViewModel.isFavoritePost(at: indexPath.row)
        
        cell.setupInfo(post: post, isFavorite: isFavoritePost)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToDetailVC(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension BasePostViewController: CustomCellDelegate {
    func didLongPressOnCell(_ cell: CustomTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            baseViewModel.setIndexToUpdate(indexPath.row)
            baseViewModel.preparingDataForSaving(at: indexPath.row)
        }
    }
}
