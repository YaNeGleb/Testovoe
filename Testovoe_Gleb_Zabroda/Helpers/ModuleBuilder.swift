import UIKit

struct ModuleBuilder {
    static func createTabBarController() -> UITabBarController {
        let postService = PostService()
        
        let mostEmailedVC = createMostEmailedVC(postService: postService)
        let mostSharedVC = createMostSharedVC(postService: postService)
        let mostViewedVC = createMostViewedVC(postService: postService)
        let favoritePostsVC = createFavoritePostsVC()
                
        let mostEmailedTabBarImage = UIImage(systemName: "mail.stack.fill")
        let mostEmailedTabBarItem = UITabBarItem(title: "Most Emailed",
                                                 image: mostEmailedTabBarImage,
                                                 selectedImage: nil)
        mostEmailedVC.tabBarItem = mostEmailedTabBarItem
        mostEmailedVC.title = "Most Emailed"
        
        let mostSharedTabBarImage = UIImage(systemName: "arrowshape.turn.up.right.fill")
        let mostSharedTabBarItem = UITabBarItem(title: "Most Shared",
                                                image: mostSharedTabBarImage,
                                                selectedImage: nil)
        mostSharedVC.tabBarItem = mostSharedTabBarItem
        mostSharedVC.title = "Most Shared"
        
        let mostViewedTabBarImage = UIImage(systemName: "eye.fill")
        let mostViewedTabBarItem = UITabBarItem(title: "Most Viewed",
                                                image: mostViewedTabBarImage,
                                                selectedImage: nil)
        mostViewedVC.tabBarItem = mostViewedTabBarItem
        mostViewedVC.title = "Most Viewed"
        
        let favoriteTabBarImage = UIImage(systemName: "star")
        let favoriteTabBarItem = UITabBarItem(title: "Favorite",
                                              image: favoriteTabBarImage,
                                              selectedImage: nil)
        favoritePostsVC.tabBarItem = favoriteTabBarItem
        favoritePostsVC.title = "Favorite"
        
        let navEmailed = UINavigationController(rootViewController: mostEmailedVC)
        let navShared = UINavigationController(rootViewController: mostSharedVC)
        let navViewed = UINavigationController(rootViewController: mostViewedVC)
        let navFavorite = UINavigationController(rootViewController: favoritePostsVC)
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([navEmailed, navShared, navViewed, navFavorite], animated: true)
        tabBarController.tabBar.tintColor = .orange
        tabBarController.tabBar.barTintColor = .black
        return tabBarController
    }
    
    static func createMostEmailedVC(postService: PostServiceProtocol) -> MostEmailedViewController {
        let mostEmailedViewModel = MostEmailedViewModel(postService: postService)
        let mostEmailedVC = MostEmailedViewController(viewModel: mostEmailedViewModel)
        return mostEmailedVC
    }
    
    static func createMostSharedVC(postService: PostServiceProtocol) -> MostSharedViewController {
        let mostSharedViewModel = MostSharedViewModel(postService: postService)
        let mostSharedVC = MostSharedViewController(viewModel: mostSharedViewModel)
        return mostSharedVC
    }
    
    static func createMostViewedVC(postService: PostServiceProtocol) -> MostViewedViewController {
        let mostViewedViewModel = MostViewedViewModel(postService: postService)
        let mostViewedVC = MostViewedViewController(viewModel: mostViewedViewModel)
        return mostViewedVC
    }
    
    static func createFavoritePostsVC() -> FavoritePostsViewController {
        let favoriteViewModel = FavoritePostsViewModel()
        let favoriteViewController = FavoritePostsViewController(viewModel: favoriteViewModel)
        return favoriteViewController
    }
    
    static func createDetailPostVC(post: Post) -> DetailPostViewController {
        let detailViewModel = DetailPostViewModel(post: post)
        let detailViewController = DetailPostViewController(viewModel: detailViewModel)
        return detailViewController
    }
    
    static func createFavoriteDetailVC(post: FavoritePostEntity) -> FavoriteDetailViewController {
        let detailViewModel = FavoriteDetailViewModel(post: post)
        let detailViewController = FavoriteDetailViewController(viewModel: detailViewModel)
        return detailViewController
    }
}

