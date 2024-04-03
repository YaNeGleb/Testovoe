import Foundation

protocol BasePostsViewModelProtocol: PostsCoreDataProtocol, PostsTableViewProtocol {
    func getPost(index: Int) -> Post?
}
