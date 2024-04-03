import Foundation

// MARK: - Post
struct Post: Codable {
    let url: String
    let source: Source
    let publishedDate: String
    let title, abstract: String
    let media: [Media]

    enum CodingKeys: String, CodingKey {
        case url
        case source
        case publishedDate = "published_date"
        case abstract
        case title
        case media
    }
}
