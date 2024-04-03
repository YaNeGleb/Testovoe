import UIKit

class FavoritePostsViewController: UIViewController {
    var viewModel: FavoritePostsViewModelProtocol
    
    private var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(FavoritePostTableViewCell.self,
                           forCellReuseIdentifier: FavoritePostTableViewCell.reuseIdentifier)
        tableView.separatorColor = UIColor.lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var emptyListImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "emptyImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(viewModel: FavoritePostsViewModelProtocol) {
        self.viewModel = viewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchPosts()
        checkEmptyList()
    }
    
    private func observeViewModel() {
        viewModel.onFetchPosts = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        configureDeleteAllButton()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureDeleteAllButton() {
        let deleteAllButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAllButtonTapped))
        deleteAllButton.tintColor = .orange
        navigationItem.rightBarButtonItem = deleteAllButton
    }
        
    @objc private func deleteAllButtonTapped() {
        viewModel.deleteAllFavoritePosts()
        checkEmptyList()
    }
    
    private func pushToDetailVC(index: Int) {
        let detailVC = viewModel.didSelectPost(at: index)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func checkEmptyList() {
        if viewModel.numberOfPosts() == 0 {
            view.addSubview(emptyListImageView)
            NSLayoutConstraint.activate([
                emptyListImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                emptyListImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                emptyListImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                emptyListImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            emptyListImageView.removeFromSuperview()
        }
    }
}

extension FavoritePostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePostTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? FavoritePostTableViewCell else {
            return UITableViewCell()
        }
        let post = viewModel.getPost(index: indexPath.row)
        cell.setUpInfo(post: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToDetailVC(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteFavoritePost(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
