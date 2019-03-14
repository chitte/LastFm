

import Foundation

protocol DataCompletionDelegate {
    func albumsDataFetched()
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
}
