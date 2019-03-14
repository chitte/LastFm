

import Foundation

struct Albums: Codable {
    var results: Results
}

struct Results: Codable {
    var albummatches: AlbumData
    struct AlbumData: Codable {
        var album: [Album]
    }
}

struct Album: Codable {
    var name: String
    var artist: String
    var url: String
    var image: [Images]
}

struct Images: Codable {
    var text: String
    var size: String

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}
