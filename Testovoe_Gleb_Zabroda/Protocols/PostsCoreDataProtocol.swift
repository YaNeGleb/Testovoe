import Foundation

protocol PostsCoreDataProtocol {
    func preparingDataForSaving(at index: Int)
    func setIndexToUpdate(_ index: Int)
    func isFavoritePost(at index: Int) -> Bool
}
