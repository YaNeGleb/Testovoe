import Alamofire

protocol PostServiceProtocol {
    func fetchMostEmailedPosts(completion: @escaping(Result<Posts, Error>) -> Void)
    func fetchMostSharedPosts(completion: @escaping(Result<Posts, Error>) -> Void)
    func fetchMostViewedPosts(completion: @escaping(Result<Posts, Error>) -> Void)
}

class PostService: PostServiceProtocol {
    private let apiKey = "5A49Zi58yI7ERW3aB1z41l0eZUg48pnN"
    private let baseUrl = "https://api.nytimes.com/svc/mostpopular/v2/"
    
    private func fetchPosts(from endPoint: String, completion: @escaping(Result<Posts, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)\(endPoint)?api-key=\(apiKey)")!
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let posts = try decoder.decode(Posts.self, from: data)
                    completion(.success(posts))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMostEmailedPosts(completion: @escaping(Result<Posts, Error>) -> Void) {
        fetchPosts(from: "emailed/30.json", completion: completion)
    }
    
    func fetchMostSharedPosts(completion: @escaping(Result<Posts, Error>) -> Void) {
        fetchPosts(from: "shared/30.json", completion: completion)
    }
    
    func fetchMostViewedPosts(completion: @escaping(Result<Posts, Error>) -> Void) {
        fetchPosts(from: "viewed/30.json", completion: completion)
    }
}

