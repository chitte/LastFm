
import Foundation

class Webservice {

    // ALBUM INFO API
    // let ALBUMS_INFO_API = "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=7677c6773ed8cfeb5f2eb7de4728ea02&artist=Cher&album=Believe&format=json"

    // ALBUM SEARCH API
    // let ALBUMS_SEARCH_API = "http://ws.audioscrobbler.com/2.0/?method=album.search&album=believe&api_key=7677c6773ed8cfeb5f2eb7de4728ea02&format=json"

    // ALBUM INFO API
    private let infoURL = URL(string: "\(BASE_URL)?method=album.getinfo&album=believe&api_key=\(API_KEY)&format=json")!

    // ALBUM SEARCH API
    private let albumsURL = URL(string: "\(BASE_URL)?method=album.search&album=believe&api_key=\(API_KEY)&format=json")!

    public func getAlbumsData(completion: @escaping (Albums) -> Void) {
        URLSession.shared.dataTask(with: albumsURL) {data, error,_ in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let jsonData = try decoder.decode(Albums.self, from: data)
                    DispatchQueue.main.async {
                        completion(jsonData)
                    }
                } catch {
                    print("error trying to convert data to JSON")
                    print("JSON ERROR = \(error.localizedDescription)")
                }
            }

            if(error != nil) {
                print("API ERROR = \(String(describing: error?.description))")
            }

        }.resume()
    }

}


