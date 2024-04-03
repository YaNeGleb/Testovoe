import Foundation
import UIKit

class MostEmailedViewModel: BasePostsViewModel {
    
    override func fetchPosts() {
        super.fetchPosts()
        
        postService.fetchMostEmailedPosts { [weak self] result in
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
