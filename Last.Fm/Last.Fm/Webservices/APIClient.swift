
import Foundation
import Alamofire

//enum MyResult<T, E: Error> {
//    case success(T)
//    case failure(E)
//}

class Webservice {
    var statusCode: Int = 0

    func fetchAlbums<T: Decodable>(_ url: String, completion: @escaping (T?, ServiceError?) -> Void) {
        print("fetchAlbums URL = \(url)")

        Alamofire.request(url).responseData { response in
            if let error = response.error {
                print("INFO API ERROR = \(String(describing: error.localizedDescription))")
                completion(nil, ServiceError.networkError)
            }

            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200:
                    if let data = response.data {
                        let decoder = JSONDecoder()
                        do {
                            let jsonData = try decoder.decode(T.self, from: data)
                            DispatchQueue.main.async {
                                completion(jsonData, nil)
                            }
                        } catch {
                            completion(nil, ServiceError.jsonError)
                        }
                    }
                case APIErrorCode.AUTHENTICATION_FAILED.rawValue:
                    completion(nil, ServiceError.authenticationFailed)
                case APIErrorCode.INVALID_APIKEY.rawValue:
                    completion(nil, ServiceError.invalidAPIKey)
                case APIErrorCode.INVALID_FORMAT.rawValue:
                    completion(nil, ServiceError.invalidFormat)
                case APIErrorCode.INVALID_METHOD.rawValue:
                    completion(nil, ServiceError.InvalidMethod)
                case APIErrorCode.INVALID_METHOD_SIGNATURE_SPECIFIED.rawValue:
                    completion(nil, ServiceError.invalidMethodSignatureSpecified)
                case APIErrorCode.INVALID_PARAMETERS.rawValue:
                    completion(nil, ServiceError.invalidParameters)
                case APIErrorCode.INVALID_RESOURCE_SPECIFIED.rawValue:
                    completion(nil, ServiceError.invalidResourceSpecified)
                case APIErrorCode.INVALID_SERVICE.rawValue:
                    completion(nil, ServiceError.invalidService)
                case APIErrorCode.INVALID_SESSION_KEY.rawValue:
                    completion(nil, ServiceError.invalidSessionKey)
                case APIErrorCode.OPERATION_FAILED.rawValue:
                    completion(nil, ServiceError.operationFailed)
                case APIErrorCode.RATE_LIMIT_EXCEEDED.rawValue:
                    completion(nil, ServiceError.rateLimitExceeded)
                case APIErrorCode.SERVICE_OFFLINE.rawValue:
                    completion(nil, ServiceError.serviceOffline)
                case APIErrorCode.SUSPENDED_APIKEY.rawValue:
                    completion(nil, ServiceError.suspendedAPIKey)
                case APIErrorCode.TEMPORARY_ERROR.rawValue:
                    completion(nil, ServiceError.temporaryError)
                default: break
                }
            }
        }
    }
}
