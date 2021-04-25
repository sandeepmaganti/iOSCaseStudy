import Foundation

typealias ResultCallback<T> = (Result<T, NetworkStackError>) -> Void

enum NetworkStackError: Error {
    case invalidRequest
    case dataMissing
    case endpointNotMocked
    case mockDataMissing
    case responseError(error: Error)
    case parserError(error: Error)
}

//Web service

protocol WebServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, completition: @escaping ResultCallback<T>)
}

class WebService: WebServiceProtocol {
    private let urlSession: URLSession
    private let parser: Parser
    private let networkActivity: NetworkActivityProtocol

    init(urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default),
         parser: Parser = Parser(),
         networkActivity: NetworkActivityProtocol = NetworkActivity()) {
        self.urlSession = urlSession
        self.parser = parser
        self.networkActivity = networkActivity
    }

    func request<T: Decodable>(_ endpoint: Endpoint, completition: @escaping ResultCallback<T>) {

        guard let request = endpoint.request else {
            OperationQueue.main.addOperation({ completition(.failure(NetworkStackError.invalidRequest)) })
            return
        }

        networkActivity.increment()

        let task = urlSession.dataTask(with: request) {(data, response, error) in

            self.networkActivity.decrement()

            if let error = error {
                OperationQueue.main.addOperation({ completition(.failure(.responseError(error: error))) })
                return
            }

            guard let data = data else {
                OperationQueue.main.addOperation({ completition(.failure(NetworkStackError.dataMissing)) })
                return
            }

            self.parser.json(data: data, completition: completition)
        }

        task.resume()
    }
}

// Network Activity

enum NetworkActivityState {
    case show
    case hide
}

protocol NetworkActivityProtocol {
    func increment()
    func decrement()
    func observe(using closure: @escaping (NetworkActivityState) -> Void)
}

class NetworkActivity: NetworkActivityProtocol {
    private var observations = [(NetworkActivityState) -> Void]()

    private var activityCount: Int = 0 {
        didSet {

            if (activityCount < 0) {
                activityCount = 0
            }

            if (oldValue > 0 && activityCount > 0) {
                return
            }

            stateDidChange()
        }
    }

    private func stateDidChange() {

        let state = activityCount > 0 ? NetworkActivityState.show : NetworkActivityState.hide
        observations.forEach { closure in
             OperationQueue.main.addOperation({ closure(state) })
        }
    }

    func increment() {
        self.activityCount += 1
    }

    func decrement() {
        self.activityCount -= 1
    }

    func observe(using closure: @escaping (NetworkActivityState) -> Void) {
        observations.append(closure)
    }
}

//End point
protocol Endpoint {
    var request: URLRequest? { get }
    var httpMethod: String { get }
    var httpHeaders: [String : String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var scheme: String { get }
    var host: String { get }
}

extension Endpoint {
    func request(forEndpoint endpoint: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = endpoint
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod

        if let httpHeaders = httpHeaders {
            for (key, value) in httpHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
}
