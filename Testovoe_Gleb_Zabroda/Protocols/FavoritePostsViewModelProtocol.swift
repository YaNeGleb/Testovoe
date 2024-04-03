import Foundation

protocol FavoritePostsViewModelProtocol: PostsTableViewProtocol {
    func deleteFavoritePost(at index: Int)
    func deleteAllFavoritePosts()
    func getPost(index: Int) -> FavoritePostEntity
}
