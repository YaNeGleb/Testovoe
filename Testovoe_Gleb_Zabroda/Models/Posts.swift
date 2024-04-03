import Foundation

// MARK: - Posts
struct Posts: Codable {
    let status, copyright: String
    let numResults: Int
    let results: [Post]
    
    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}
