
import UIKit

class AlbumInfoVC: UIViewController, InfoFetchDelegate, UITableViewDelegate, UITableViewDataSource, ErrorDelegate {
    var album: String?
    var artist: String?

    let wikiView = UIView()
    let textView = UITextView()
    var closeButton = UIButton()

    @IBOutlet var albumImage: UIImageView!
    @IBOutlet var albumName: UILabel!

    @IBOutlet var playCountInfo: UILabel!
    @IBOutlet var listenersInfo: UILabel!
    @IBOutlet var infoTableView: UITableView!

    @IBOutlet var wikiInfoBtn: UIButton!
    var albumInfoViewModel = AlbumInfoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        albumInfoViewModel.dataDelegate = self
        albumInfoViewModel.errDelegate = self

        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        infoTableView.tableFooterView = UIView(frame: .zero)


        wikiView.frame = CGRect(x: 15, y: 100, width: screenWidth - 30, height: screenHeight - 130)
        wikiView.backgroundColor = UIColor.lightText
        wikiView.layer.cornerRadius = 8
        wikiView.layer.borderWidth = 2
        wikiView.layer.borderColor = UIColor.orange.cgColor
        view.addSubview(wikiView)
        wikiView.isHidden = true

        wikiInfoBtn.isUserInteractionEnabled = true

        // Fetch Album Information
        showAnimation(rootVC: self, shouldStartAnimation: true)
        albumInfoViewModel.fetchAlbumInformation(artist: artist!, album: album!)
    }

    func sendErrorInfoToUI(errMsg: String) {
        print("Error Received")
        DispatchQueue.main.async {
            self.wikiInfoBtn.isUserInteractionEnabled = false
            showAnimation(rootVC: self, shouldStartAnimation: false)
            showErrorDialogBox(on: self, with: errMsg)
        }
    }

    func albumsInfoDataFetched() {
        print("albumsInfoDataFetched")
        showAnimation(rootVC: self, shouldStartAnimation: false)

        // Fill Up AlbumInfoDetails
        navigationItem.title = albumInfoViewModel.getArtist()

        albumName.text = albumInfoViewModel.getAlbumName()
        playCountInfo.text = "Players \((formatNumber(Int(albumInfoViewModel.getPlayCount())!)))"
        listenersInfo.text = "Listeners \((formatNumber(Int(albumInfoViewModel.getListenersCount())!)))"

        let albumImageStr = albumInfoViewModel.getAlbumInfoImageWith(size: ImageSize.large)
        if let url = URL(string: albumImageStr!) {
            getImageData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    let img = UIImage(data: data)
                    self.albumImage.image = img
                }
            }
        }

        infoTableView.reloadData()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let trackInfoDetail = albumInfoViewModel.getAlbumTrackDetails(at: indexPath.row)
        if let trackName =  trackInfoDetail?.name, let trackDuration = trackInfoDetail?.duration {
            cell.textLabel?.text = "\(indexPath.row + 1). \(trackName) Duration: \(trackDuration)"
        } else {
            cell.textLabel?.text = "No Track Info Found"
        }
        return cell
    }

    public func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return IS_IPAD ? 64 : 44
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return albumInfoViewModel.getTracksCount()
    }

    @IBAction func wikiInfoAction(_ sender: Any) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        wikiView.isHidden = false
        wikiInfoBtn.isUserInteractionEnabled = false

        let wikiInfo = albumInfoViewModel.getAlbumWikiInfo()

        textView.removeFromSuperview()
        textView.frame = CGRect(x: 0, y: 0, width: wikiView.frame.width, height: wikiView.frame.height)
        textView.textAlignment = NSTextAlignment.justified
        if let publishedText =  wikiInfo?.published,
            let summaryText = wikiInfo?.summary,
            let content = wikiInfo?.content {
            textView.text = "\nPublished: \(publishedText) \n\nSummary: \(summaryText) \n\nContent: \(content) \n"
        } else {
            textView.text = "Wiki Information Not Available"
        }

        textView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75)
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: IS_IPAD ? 28 : 20)
        textView.isSelectable = true
        textView.isEditable = false
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        textView.layer.cornerRadius = 10
        textView.autocorrectionType = UITextAutocorrectionType.yes
        textView.spellCheckingType = UITextSpellCheckingType.yes
        wikiView.addSubview(textView)

        closeButton.removeFromSuperview()
        closeButton.frame = CGRect(x: wikiView.frame.width - 46, y: 2, width: 44, height: 44)
        closeButton.backgroundColor = UIColor.clear
        closeButton.setTitle("x", for: UIControl.State.normal)
        closeButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: IS_IPAD ? 40 : 30)
        closeButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        wikiView.addSubview(closeButton)
    }

    @objc func buttonClicked() {
        print("Button Clicked")
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        wikiView.isHidden = true
        wikiInfoBtn.isUserInteractionEnabled = true
    }
}
