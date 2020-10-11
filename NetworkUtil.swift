final class NetworkUtil {
    enum HTTPMethod {
        case get
        case post
        case put
        case patch
        case delete
        
        var toString: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            case .patch:
                return "PATCH"
            case .delete:
                return "DELETE"
            }
        }
    }
    
    static func request<T: Decodable>(from urlString: String, httpMethod: HTTPMethod = .get, parameters: [String: Any]?, onSuccess: @escaping (T) -> Void, onFailure: @escaping (Error) -> Void) {
        guard let url: URL = URL(string: urlString) else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.toString
        
        if let parameters: [String: Any] = parameters, let parametersData: Data = try? JSONSerialization.data(withJSONObject: parameters) {
            urlRequest.httpBody = parametersData
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error: Error = error {
                    onFailure(error)
                }
                else if let data: Data = data {
                    do {
                        let result: T = try JSONDecoder().decode(T.self, from: data)
                        
                        onSuccess(result)
                    }
                    catch {
                        onFailure(error)
                    }
                }
            }
        }.resume()
    }
}
