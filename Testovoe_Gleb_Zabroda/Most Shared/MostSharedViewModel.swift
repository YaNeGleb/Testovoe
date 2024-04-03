import UIKit

class MostSharedViewModel: BasePostsViewModel {
    
    override func fetchPosts() {
        super.fetchPosts()
        
        postService.fetchMostSharedPosts { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts.results.sorted(by: { $0.publishedDate > $1.publishedDate })
            case .failure(let error):
                self?.onActionWithError?()
                print(error)
            }
            self?.isLoadingCompletion?(false)
        }
    }
}
