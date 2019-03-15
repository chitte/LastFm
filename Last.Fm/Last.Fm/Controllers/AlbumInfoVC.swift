
import UIKit

class AlbumInfoVC: UIViewController, InfoFetchDelegate {
    var album: String?
    var artist: String?

    @IBOutlet var albumImage: UIImageView!
    @IBOutlet var albumName: UILabel!

    @IBOutlet var playCountInfo: UILabel!
    @IBOutlet var listenersInfo: UILabel!
    @IBOutlet var infoTableView: UITableView!

    @IBOutlet var wikiInfoBtn: UIButton!
    var albumInfoViewModel = AlbumInfoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        albumInfoViewModel.delegate = self

        albumImage.layer.borderColor = UIColor.orange.cgColor
        albumImage.layer.borderWidth = 0.5
        albumImage.layer.cornerRadius = albumImage.frame.width / 2

        // Fetch Album Information
        albumInfoViewModel.fetchAlbumInformation(artist: artist!, album: album!)
    }

    func albumsInfoDataFetched() {
        print("albumsInfoDataFetched")

        navigationItem.title = albumInfoViewModel.getArtist()

        // Fill Up AlbumInfoDetails
        albumName.text = albumInfoViewModel.getAlbumName()
        playCountInfo.text = "Players \((formatNumber(Int(albumInfoViewModel.getPlayCount())!)))"
        listenersInfo.text = "Listeners \((formatNumber(Int(albumInfoViewModel.getListenersCount())!)))"

        let albumImageStr = albumInfoViewModel.getAlbumInfoImageWith(size: ImageSize.large)
        if let url = URL(string: albumImageStr!) {
            getImageData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                // print(response?.suggestedFilename ?? url.lastPathComponent)
                // print("Download Finished")
                DispatchQueue.main.async() {
                    let img = UIImage(data: data)
                    self.albumImage.image = img
                }
            }
        }

    }

    @IBAction func wikiInfoAction(_ sender: Any) {
        let wikiInfo = albumInfoViewModel.getAlbumWikiInfo()
        print("\(String(describing: wikiInfo?.published))")
        print("\(String(describing: wikiInfo?.summary))")
        print("\(String(describing: wikiInfo?.content))")
    }
}
