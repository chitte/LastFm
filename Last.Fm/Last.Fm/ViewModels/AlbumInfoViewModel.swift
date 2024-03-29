

import Foundation

class AlbumInfoViewModel {
    private var webService = Webservice()
    private var albumInfoDetails: AlbumDetails?

    var dataDelegate: InfoFetchDelegate?
    var errDelegate: ErrorDelegate?

    func fetchAlbumInformation(artist: String, album: String) {
        let infoURL = "\(albumsBaseInfoURL)&artist=\(artist)&album=\(album)&format=json"
        var resultInfoURL = infoURL.removingPercentEncoding
        resultInfoURL = resultInfoURL?.replacingOccurrences(of: " ", with: "")

        webService.fetchAlbums(resultInfoURL!) { (data: AlbumDetails?, error) in
            if error != nil {
                self.errDelegate?.sendErrorInfoToUI(errMsg: (error)!.rawValue)
            } else {
                self.albumInfoDetails = data
                self.dataDelegate?.albumsInfoDataFetched()
            }
        }
    }

    func getAlbumName() -> String {
        guard let album = self.albumInfoDetails?.album.name else {
            return ""
        }
        return album
    }

    func getArtist() -> String {
        guard let artist = self.albumInfoDetails?.album.artist else {
            return ""
        }
        return artist
    }

    func getListenersCount() -> String {
        guard let listenersCount = self.albumInfoDetails?.album.listeners else {
            return ""
        }
        return listenersCount
    }

    func getPlayCount() -> String {
        guard let playCount = self.albumInfoDetails?.album.playcount else {
            return ""
        }
        return playCount
    }

    func getAlbumInfoImageWith(size: ImageSize) -> String? {
        guard let imagesArray = self.albumInfoDetails?.album.image else {
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

    func getTracksCount() -> Int {
        guard let count = self.albumInfoDetails?.album.tracks.track.count else {
            return 0
        }
        return count
    }

    func getAlbumTrackDetails(at index: Int) -> (name: String, duration: String)? {
        guard let trackInfo = self.albumInfoDetails?.album.tracks.track[index] else {
            return nil
        }

        return (trackInfo.name, trackInfo.duration)
    }

    func getAlbumWikiInfo() -> WikiInfo? {
        guard let wikiInfo = self.albumInfoDetails?.album.wiki else {
            return nil
        }
        return wikiInfo
    }
}
