import Foundation

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.target.com"
    }
}

enum ProductsEndpoint {
    case all
    case get(productId: Int)
}

extension ProductsEndpoint: Endpoint {

    var endPoint: String {
        return "/mobile_case_study_deals/v1/deals/"
    }

    var request: URLRequest? {
        switch self {
        case .all:
            return request(forEndpoint: endPoint)
        case .get(let productId):
            return request(forEndpoint: "\(endPoint)\(productId)")
        }
    }

    var httpMethod: String {
        switch self {
        case .all:
            return "GET"
        case .get( _):
            return "GET"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .all:
            return nil
        case .get(let productId):
            return [URLQueryItem(name: "productId", value: String(productId))]
        }
    }

    var httpHeaders: [String: String]? {
        let headers: [String: String] = [
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        ]
        switch self {
        case .all, .get( _):
            return headers
        }
    }
}
