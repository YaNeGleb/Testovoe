import UIKit

class FavoritePostsViewModel: FavoritePostsViewModelProtocol {
    var onFetchPosts: (() -> Void)?
    var onActionWithPost: ((Int) -> Void)?
    var onActionWithError: (() -> Void)?
    var isLoadingCompletion: ((Bool) -> Void)?
    
    var favoritePosts: [FavoritePostEntity] = [] {
        didSet {
            onFetchPosts?()
        }
    }
    
    func numberOfPosts() -> Int {
        return favoritePosts.count
    }
    
    func fetchPosts() {
        isLoadingCompletion?(true)
        let posts = CoreDataManager.shared.fetchFavoritePosts()
        favoritePosts = posts
        isLoadingCompletion?(false)
    }
    
    func deleteFavoritePost(at index: Int) {
        let deletedPost = favoritePosts[index]
        CoreDataManager.shared.deleteFavoritePostEntity(deletedPost)
        fetchPosts()
        onFetchPosts?()
    }
    
    func getPost(at index: Int) -> FavoritePostEntity {
        let currentPost = favoritePosts[index]
        return currentPost
    }
    
    func deleteAllFavoritePosts() {
        for post in favoritePosts {
            CoreDataManager.shared.deleteFavoritePostEntity(post)
        }
        fetchPosts()
        onFetchPosts?()
    }
    
    func getPost(index: Int) -> FavoritePostEntity {
        let post = favoritePosts[index]
        return post
    }
    
    func didSelectPost(at index: Int) -> UIViewController {
        let currentPost = favoritePosts[index]
        let detailsVC = ModuleBuilder.createFavoriteDetailVC(post: currentPost)
        return detailsVC
    }
}
