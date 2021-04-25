import Foundation

protocol ParserProtocol {
    func json<T: Decodable>(data: Data, completition: @escaping ResultCallback<T>)
}

struct Parser {
    let jsonDecoder = JSONDecoder()

    func json<T: Decodable>(data: Data, completition: @escaping ResultCallback<T>) {
        do {
            let result: T = try jsonDecoder.decode(T.self, from: data)
            OperationQueue.main.addOperation { completition(.success(result)) }

        } catch let error {
            OperationQueue.main.addOperation { completition(.failure(.parserError(error: error))) }
        }
    }
}
