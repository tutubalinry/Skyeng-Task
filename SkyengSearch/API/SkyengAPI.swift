import Moya

enum SkyengAPI {
    case search(word: String, page: Int, pageSize: Int) //https://dictionary.skyeng.ru/api/public/v1/words/search?search=""
}

extension SkyengAPI {
    
    var parameters: [String : Any] {
        switch self {
        case let .search(word: word, page: page, pageSize: pageSize):
            return ["search" : word, "page" : page, "pageSize" : pageSize]
        }
    }
    
}

extension SkyengAPI: TargetType {
    
    var baseURL: URL {
        URL(string: "https://dictionary.skyeng.ru/api/public/v1/")!
    }
    
    var path: String {
        switch self {
        case .search:
            return "words/search"
        }
    }
    
    var method: Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .search:
            return Task.requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var sampleData: Data {
        Data()
    }
}
