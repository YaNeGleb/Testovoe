import Foundation
import CoreData

@objc(FavoritePostEntity)
public class FavoritePostEntity: NSManagedObject {}
    
extension FavoritePostEntity {
    @NSManaged public var url: String
    @NSManaged public var source: String
    @NSManaged public var publishedDate: String
    @NSManaged public var title: String
    @NSManaged public var abstract: String
    @NSManaged public var addedDate: String
}

extension FavoritePostEntity: Identifiable {}
