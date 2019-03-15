
import Foundation

//{"error":6,"message":"Album not found","links":[]}

struct ErrorType: Codable {
    var error: String?
    var message: String?
}

struct AlbumDetails: Codable {
    var album: AlbumInfo
}

struct AlbumInfo: Codable {
    var name: String
    var artist: String
    var image: [AlbumImage]
    var listeners: String
    var playcount: String

    var tracks: TrackInfo
    struct TrackInfo: Codable {
        var track: [Track]
    }

    var wiki: WikiInfo?
}

struct AlbumImage: Codable {
    var text: String
    var size: String

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

struct Track: Codable {
    var name: String
    var url: String
    var duration: String
}

struct WikiInfo: Codable {
    var published: String
    var summary: String
    var content: String
}
