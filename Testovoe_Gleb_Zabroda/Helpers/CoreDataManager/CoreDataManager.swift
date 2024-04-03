import UIKit
import CoreData

public final class CoreDataManager: NSObject {
    
    static let shared = CoreDataManager()
    private override init() {}
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { description, error in
            if let error {
                print(error.localizedDescription)
            } else {
                print("Database URL -", description.url?.absoluteString)
            }
        }
        return container
    }()
    
    func createFavoritePost(post: FavoritePost, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritePostEntity")
            fetchRequest.predicate = NSPredicate(format: "title == %@", post.title)
            
            do {
                if let existingPost = try self.context.fetch(fetchRequest).first as? FavoritePostEntity {
                    existingPost.title = post.title
                    existingPost.abstract = post.abstract
                    existingPost.addedDate = post.addedDate
                    existingPost.url = post.url
                    existingPost.source = post.source
                    existingPost.publishedDate = post.publishedDate
                    completion(true)
                    print("Updated existing post with title:", post.title)
                } else {
                    guard let postEntityDescription = NSEntityDescription.entity(forEntityName: "FavoritePostEntity", in: self.context) else {
                        completion(false)
                        print("ERROR CREATING POST ENTITY DESCRIPTION")
                        return
                    }
                    
                    let favoritePost = FavoritePostEntity(entity: postEntityDescription, insertInto: self.context)
                    favoritePost.title = post.title
                    favoritePost.abstract = post.abstract
                    favoritePost.addedDate = post.addedDate
                    favoritePost.url = post.url
                    favoritePost.source = post.source
                    favoritePost.publishedDate = post.publishedDate
                    
                    completion(true)
                    print("FAVORITE POST COMPLETE ADD")
                    
                    do {
                        try self.context.save()
                    } catch {
                        completion(false)
                        print("Error saving context: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Error checking for existing post: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFavoritePosts() -> [FavoritePostEntity] {
        let fetchRequest = NSFetchRequest<FavoritePostEntity>(entityName: "FavoritePostEntity")
        
        let sortDescriptor = NSSortDescriptor(key: "addedDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.isEmpty {
                print("No favorite posts found")
            }
            return result
        } catch {
            print("Error fetching favorite posts: \(error.localizedDescription)")
            return []
        }
    }
    
    func isPostsInFavorites(title: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritePostEntity")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error checking for existing post: \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteFavoritePostEntity(_ post: FavoritePostEntity) {
        context.delete(post)
        saveContext()
    }
    
    func deleteFavoritePost(for favoritePost: FavoritePost) {
        let fetchRequest = NSFetchRequest<FavoritePostEntity>(entityName: "FavoritePostEntity")
        fetchRequest.predicate = NSPredicate(format: "title == %@", favoritePost.title)
        
        do {
            if let favoritePostEntity = try context.fetch(fetchRequest).first {
                context.delete(favoritePostEntity)
                saveContext()
            }
        } catch {
            print("Error deleting favorite post entity: \(error.localizedDescription)")
        }
    }

    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("ERROR SAVE CONTEXT")
            }
        }
    }
}
