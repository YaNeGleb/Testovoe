import Foundation

protocol DetailPostViewModelProtocol {
    var post: Post { get }
}

class DetailPostViewModel: DetailPostViewModelProtocol {
    var post: Post
    
    init(post: Post) {
        self.post = post
    }
}
