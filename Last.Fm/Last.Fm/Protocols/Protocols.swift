
import Foundation

protocol ErrorDelegate {
    func sendErrorInfoToUI(errMsg: String)
}

protocol DataCompletionDelegate {
    func albumsDataFetched()
}

protocol InfoFetchDelegate {
    func albumsInfoDataFetched()
}
