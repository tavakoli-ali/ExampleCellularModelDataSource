import Foundation

public typealias APIServiceCompletion = (_ data: Data?, _ reponse: URLResponse?, _ error: Error?) -> Void

protocol APIService {
    func dispatch(apiRequest: RequestEndPoint, completion: @escaping APIServiceCompletion)
}
