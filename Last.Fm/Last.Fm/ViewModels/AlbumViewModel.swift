

import Foundation

protocol DataCompletionDelegate {
    func albumsDataFetched()
    func albumsInformationFetched()
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
    private var filteredAlbums: Albums?

    private var albumDetails: AlbumDetails?

    var delegate: DataCompletionDelegate?

    func fetchAlbumData() {
        webService.getAlbumsData { (data) in
            self.albums = data
            self.filteredAlbums = self.albums
            self.delegate?.albumsDataFetched()
        }
    }

    func fetchAlbumInformation(artist: String, album: String) {
        webService.getAlbumsInformation(artist: artist, album: album) { data in
            self.albumDetails = data
            self.delegate?.albumsInformationFetched()
        }
    }

    func getAlbumCount() -> Int {
        guard let count = self.filteredAlbums?.results.albummatches.album.count else {
            return 0
        }
        return count
    }

    func fetchAlbumName(in index: Int) -> String {
        guard let artist = self.filteredAlbums?.results.albummatches.album[index].name else {
            return ""
        }
        return artist
    }

    func fetchArtistNmae(in index: Int) -> String {
        guard let albumName = self.filteredAlbums?.results.albummatches.album[index].artist else {
            return ""
        }
        return albumName
    }

    func fetchAlbumImageWith(in index: Int, size: ImageSize) -> String? {
        guard let imagesArray = self.filteredAlbums?.results.albummatches.album[index].image else {
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

    func filterAlbums(searchString: String) {
        filteredAlbums = albums
        if(searchString != "") {
            if let albumsMatched = albums?.results.albummatches.album.filter({
                $0.name.contains(searchString) ||
                    $0.artist.contains(searchString) }) {
                filteredAlbums?.results.albummatches.album = albumsMatched
            }
        }
    }

}
