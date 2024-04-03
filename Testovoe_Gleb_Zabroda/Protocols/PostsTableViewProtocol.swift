import UIKit

protocol PostsTableViewProtocol {
    var onActionWithPost: ((Int) -> Void)? { get set }
    var onActionWithError: (() -> Void)? { get set }
    var isLoadingCompletion: ((Bool) -> Void)? { get set }
    var onFetchPosts: (() -> Void)? { get set }
    
    func fetchPosts()
    func numberOfPosts() -> Int
    func didSelectPost(at index: Int) -> UIViewController
}
