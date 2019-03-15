

import Foundation

protocol DataCompletionDelegate {
    func albumsDataFetched()
}

enum ImageSize: String {
    case small = "small"
    case medium = "medium"
    case large = "large"
    case extralarge = "extralarge"
}

class AlbumViewModel {
    private var webService = Webservice()
    private var albums: Albums?

    var delegate: DataCompletionDelegate?

    func fetchAlbumData() {
        webService.getAlbumsData { (data) in
            self.albums = data
            self.delegate?.albumsDataFetched()
        }
    }

    func getAlbumCount() -> Int {
        guard let count = self.albums?.results.albummatches.album.count else {
            return 0
        }
        return count
    }

    func fetchAlbumName(index: Int) -> String {
        guard let artist = self.albums?.results.albummatches.album[index].name else {
            return ""
        }
        return artist
    }

    func fetchArtistNmae(index: Int) -> String {
        guard let albumName = self.albums?.results.albummatches.album[index].artist else {
            return ""
        }
        return albumName
    }

    func fetchAlbumImageWith(index: Int, size: ImageSize) -> String? {
        guard let imagesArray = self.albums?.results.albummatches.album[index].image else {
            return nil
        }

        var imageUrl: String?
        for imageItem in imagesArray {
            if imageItem.size == size.rawValue {
                imageUrl = imageItem.text
            }
        }
        return imageUrl
    }

}
