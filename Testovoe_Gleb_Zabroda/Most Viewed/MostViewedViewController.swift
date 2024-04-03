import UIKit

class MostViewedViewController: BasePostViewController {
    
    var viewModel: BasePostsViewModelProtocol
    
    init(viewModel: BasePostsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(baseViewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchPosts()
    }
}
