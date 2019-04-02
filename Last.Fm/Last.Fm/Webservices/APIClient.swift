
import Foundation

class Webservice {
    var statusCode: Int = 0

    public func getAlbumsData(completion: @escaping (Albums?, ServiceError?) -> Void) {
        // ALBUM SEARCH API
        let albumsURL = URL(string: "\(BASE_URL)?method=album.search&album=believe&api_key=\(API_KEY)&format=json")!
        print("albumsSearchURL = \(albumsURL)")
        URLSession.shared.dataTask(with: albumsURL) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("SEARCH STATUS CODE = \(httpResponse.statusCode)")
                self.statusCode = httpResponse.statusCode
                if self.statusCode == 200 {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let jsonData = try decoder.decode(Albums.self, from: data)
                            DispatchQueue.main.async {
                                completion(jsonData, nil)
                            }
                        } catch {
                            print("error trying to convert data to JSON")
                            print("SEARCH JSON ERROR = \(error.localizedDescription)")
                            completion(nil, ServiceError.jsonError(message: error.localizedDescription))
                        }
                    }
                } else {
                    completion(nil, ServiceError.statutsCodeError(message: self.showErrorMessage(statusCode: self.statusCode)))
                }
            }

            if error != nil {
                print("SEARCH API ERROR = \(String(describing: error?.localizedDescription))")
                completion(nil, ServiceError.networkError(message: error?.localizedDescription ?? ""))
            }

        }.resume()
    }

    public func getAlbumsInformation(artist: String, album: String, completion: @escaping (AlbumDetails?, ServiceError?) -> Void) {
        // ALBUM INFO API
        let infoURL = "\(BASE_URL)?method=album.getinfo&api_key=\(API_KEY)&artist=\(artist)&album=\(album)&format=json"
        var resultInfoURL = infoURL.removingPercentEncoding
        resultInfoURL = resultInfoURL?.replacingOccurrences(of: " ", with: "")
        print("resultInfoURL = \(resultInfoURL!)")

        let albumsInfoURL = URL(string: resultInfoURL!)
        URLSession.shared.dataTask(with: albumsInfoURL!) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                self.statusCode = httpResponse.statusCode
                print("INFO STATUS CODE = \(self.statusCode)")
                if self.statusCode == 200 {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let jsonData = try decoder.decode(AlbumDetails.self, from: data)
                            DispatchQueue.main.async {
                                completion(jsonData, nil)
                            }
                        } catch {
                            print("error trying to convert data to JSON")
                            print("INFO JSON ERROR = \(error.localizedDescription)")
                            completion(nil, ServiceError.jsonError(message: error.localizedDescription))
                        }
                    }
                } else {
                    completion(nil, ServiceError.statutsCodeError(message: self.showErrorMessage(statusCode: self.statusCode)))
                }
            }

            if error != nil {
                print("INFO API ERROR = \(String(describing: error?.localizedDescription))")
                completion(nil, ServiceError.networkError(message: error?.localizedDescription ?? ""))
            }

        }.resume()
    }

    // API ERROR MESSAGES
    func showErrorMessage(statusCode: Int) -> String {
        var errMsg: String = ""
        print("ERROR STATUS CODE = \(statusCode)")
        switch statusCode {
        case AlbumAPIErrorCode.INVALID_SERVICE.rawValue:
            errMsg = "This service does not exist"
        case AlbumAPIErrorCode.INVALID_METHOD.rawValue:
            errMsg = "No method with that name in this package"
        case AlbumAPIErrorCode.AUTHENTICATION_FAILED.rawValue:
            errMsg = "You do not have permissions to access the service"
        case AlbumAPIErrorCode.INVALID_FORMAT.rawValue:
            errMsg = "This service doesn't exist in that format"
        case AlbumAPIErrorCode.INVALID_PARAMETERS.rawValue:
            errMsg = "Your request is missing a required parameter"
        case AlbumAPIErrorCode.INVALID_RESOURCE_SPECIFIED.rawValue:
            errMsg = "INVALID_RESOURCE_SPECIFIED"
        case AlbumAPIErrorCode.OPERATION_FAILED.rawValue:
            errMsg = "Something else went wrong"
        case AlbumAPIErrorCode.INVALID_SESSION_KEY.rawValue:
            errMsg = "Please re-authenticate"
        case AlbumAPIErrorCode.INVALID_APIKEY.rawValue:
            errMsg = "You must be granted a valid key by last.fm"
        case AlbumAPIErrorCode.SERVICE_OFFLINE.rawValue:
            errMsg = "This service is temporarily offline. Try again later."
        case AlbumAPIErrorCode.INVALID_METHOD_SIGNATURE_SPECIFIED.rawValue:
            errMsg = "INVALID_METHOD_SIGNATURE_SPECIFIED"
        case AlbumAPIErrorCode.TEMPORARY_ERROR.rawValue:
            errMsg = "There was a temporary error processing your request. Please try again"
        case AlbumAPIErrorCode.SUSPENDED_APIKEY.rawValue:
            errMsg = "Access for your account has been suspended, please contact Last.fm"
        case AlbumAPIErrorCode.RATE_LIMIT_EXCEEDED.rawValue:
            errMsg = "Your IP has made too many requests in a short period"
        default:
            errMsg = "UNKNOWN"
        }
        return errMsg
    }
}
