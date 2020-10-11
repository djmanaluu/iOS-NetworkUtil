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
    
    /// Create Request with specific URL of the Endpoint, the httpMethod and parameters.
    ///
    /// - Parameters:
    ///   - urlString: API Endpoint
    ///   - httpMethod: HTTP Method (`.get`, `.post`, `.put`, `.patch`, `.delete`)
    ///   - parameters: Dictionary of the parameters (request dictionary)
    ///   - onSuccess: Block for success action
    ///   - onFailure: Block for failed action
    ///
    /// - Returns: Session Data Task of the request (URLSessionDataTask)
    @discardableResult
    static func request<T: Decodable>(from urlString: String,
                                      responseType: T.Type,
                                      httpMethod: HTTPMethod?,
                                      parameters: [String: Any]?,
                                      onSuccess: @escaping (T) -> Void,
                                      onFailure: @escaping (Error) -> Void) -> URLSessionDataTask? {
        guard let url: URL = URL(string: urlString) else { return nil }
        
        let session: URLSession = URLSession(configuration: .default)
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod?.toString
        
        if let parameters: [String: Any] = parameters, let parametersData: Data = try? JSONSerialization.data(withJSONObject: parameters) {
            urlRequest.httpBody = parametersData
        }
        
        let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { data, response, error in
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
        }
        
        dataTask.resume()
        
        return dataTask
    }
}
