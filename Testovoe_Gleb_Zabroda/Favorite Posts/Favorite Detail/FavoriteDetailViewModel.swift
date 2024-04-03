import UIKit

protocol FavoriteDetailViewModelProtocol {
    var post: FavoritePostEntity { get }
}

class FavoriteDetailViewModel: FavoriteDetailViewModelProtocol {
    
    var post: FavoritePostEntity
    
    init(post: FavoritePostEntity) {
        self.post = post
    }
}


