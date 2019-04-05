

import Foundation

enum ImageSize: String {
    case small
    case medium
    case large
    case extralarge
}

class AlbumViewModel {
    private var webService = Webservice()
    private var albums: Albums?
    private var filteredAlbums: Albums?

    var dataDelegate: DataCompletionDelegate?
    var errDelegate: ErrorDelegate?

    func fetchAlbumData() {
        webService.fetchAlbums(albumsSearchURL) { (data: Albums?, error) in
            if error != nil {
                self.errDelegate?.sendErrorInfoToUI(errMsg: (error?.localizedDescription)!)
            } else {
                self.albums = data
                self.filteredAlbums = self.albums
                self.dataDelegate?.albumsDataFetched()
            }
        }
    }

    func getAlbumCount() -> Int {
        guard let count = self.filteredAlbums?.results.albummatches.album.count else {
            return 0
        }
        return count
    }

    func fetchAlbumName(at index: Int) -> String {
        guard let artist = self.filteredAlbums?.results.albummatches.album[index].name else {
            return ""
        }
        return artist
    }

    func fetchArtistNmae(at index: Int) -> String {
        guard let albumName = self.filteredAlbums?.results.albummatches.album[index].artist else {
            return ""
        }
        return albumName
    }

    func fetchAlbumImageWith(at index: Int, size: ImageSize) -> String? {
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

    // MARK: Filter Albums based on album or artist

    func filterAlbums(searchString: String) {
        filteredAlbums = albums
        if searchString != "" {
            if let albumsMatched = albums?.results.albummatches.album.filter({
                $0.name.contains(searchString) ||
                    $0.artist.contains(searchString) }) {
                filteredAlbums?.results.albummatches.album = albumsMatched
            }
        }
    }
}
