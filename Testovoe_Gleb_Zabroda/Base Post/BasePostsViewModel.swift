import UIKit

class BasePostsViewModel: BasePostsViewModelProtocol {
    
    var isLoadingCompletion: ((Bool) -> Void)?
    var onFetchPosts: (() -> Void)?
    var onActionWithError: (() -> Void)?
    var onActionWithPost: ((Int) -> Void)?
    var onFavoritePostDeleted: ((Int) -> Void)?
    
    var postService: PostServiceProtocol
    var indexToUpdate: Int = 0
    var posts: [Post]? {
        didSet {
            onFetchPosts?()
        }
    }
    
    init(postService: PostServiceProtocol) {
        self.postService = postService
    }
    
    func numberOfPosts() -> Int {
        return posts?.count ?? 0
    }
    
    func setIndexToUpdate(_ index: Int) {
        self.indexToUpdate = index
    }
    
    func resetIndexToUpdate() {
        self.indexToUpdate = 0
    }
    
    func preparingDataForSaving(at index: Int) {
        guard let currentPost = posts?[index] else {
            onActionWithError?()
            print("WRONG GET CURRENT POST")
            return
        }
        
        let currentTime = getCurrentDateTime()
        let favoritePost = createFavoritePost(currentPost: currentPost, currentTime: currentTime)
        
        if isFavoritePost(at: index) {
            deleteFavoritePost(favoritePost: favoritePost)
        } else {
            saveFavoritePostToCoreData(favoritePost)
        }
    }
    
    func isFavoritePost(at index: Int) -> Bool {
        guard let currentPostTitle = posts?[index].title else {
            print("post title is nil at index:", index)
            onActionWithError?()
            return false
        }
        return CoreDataManager.shared.isPostsInFavorites(title: currentPostTitle)
    }
    
    func getPost(index: Int) -> Post? {
        guard let post = posts?[index] else {
            onActionWithError?()
            return nil
        }
        return post
    }
    
    func fetchPosts() {
        isLoadingCompletion?(true)
    }
    
    func didSelectPost(at index: Int) -> UIViewController {
        guard let currentPost = posts?[index] else {
            print("post at index \(index) is nil")
            onActionWithError?()
            return UIViewController()
        }
        let detailsVC = ModuleBuilder.createDetailPostVC(post: currentPost)
        return detailsVC
    }
    
    private func createFavoritePost(currentPost: Post,
                                    currentTime: String) -> FavoritePost {
        let favoritePost = FavoritePost(url: currentPost.url,
                                        source: currentPost.source.rawValue,
                                        publishedDate: currentPost.publishedDate,
                                        title: currentPost.title,
                                        abstract: currentPost.abstract,
                                        addedDate: currentTime)
        return favoritePost
    }
    
    private func saveFavoritePostToCoreData(_ favoritePost: FavoritePost) {
        CoreDataManager.shared.createFavoritePost(post: favoritePost) { [weak self] isAdded in
            guard let self else { return }
            if isAdded {
                print("Favorite post saved to Core Data")
                self.onActionWithPost?(self.indexToUpdate)
                self.resetIndexToUpdate()
            } else {
                onActionWithError?()
                print("Unknown error while saving favorite post to Core Data")
            }
        }
    }
    
    private func deleteFavoritePost(favoritePost: FavoritePost) {
        CoreDataManager.shared.deleteFavoritePost(for: favoritePost)
        self.onActionWithPost?(self.indexToUpdate)
        self.resetIndexToUpdate()
    }
    
    private func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}
