

import UIKit

class ViewController: UIViewController {

    // MARK: Properties

    @IBOutlet var collectionSearchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!

    var cellIdentifier = "Cell"
    var numberOfItemsPerRow: Int = 2
    var cellWidth: CGFloat {
        return collectionView.frame.width / 2
    }

    var albumViewModel = AlbumViewModel()
    var refreshControl = UIRefreshControl()
    var cache: NSCache<AnyObject, AnyObject>!

    let reachability = Reachability()

    // MARK: ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverForNetworkReachability()
        setUpViewController()
        addRefreshControl()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
}

// MARK: Network Reachability Observer

extension ViewController {
    func addObserverForNetworkReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("Could not strat notifier")
        }
    }
}

extension ViewController {
    func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }

    // MARK: Refresh Collection View

    @objc func refreshCollectionView() {
        internetChanged()
    }
}

extension ViewController {
    func setUpViewController() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        collectionSearchBar.delegate = self

        cache = NSCache()

        albumViewModel.dataDelegate = self
        albumViewModel.errDelegate = self
    }
}

// MARK: Detect Network Change

extension ViewController {
    @objc func internetChanged() {
        let reachability = Reachability()
        if reachability?.connection != .none {
            if reachability?.connection == .wifi {
                // Get Album Data
                showAnimation(rootVC: self, shouldStartAnimation: true)
                albumViewModel.fetchAlbumData()
            }
            else {
                DispatchQueue.main.async {
                    self.handleNoNetworkUI()
                }
            }
        } else {
            DispatchQueue.main.async {
                self.handleNoNetworkUI()
            }
        }
    }
}

// MARK: Handle No Network UI

extension ViewController {
    func handleNoNetworkUI() {
        self.showAlert(title: NetworkConnectionError.title, msg: NetworkConnectionError.networkConnection.rawValue)
        showAnimation(rootVC: self, shouldStartAnimation: false)
        self.refreshControl.endRefreshing()
        self.collectionView.reloadData()
    }
}

// MARK: Album Data Fetched

extension ViewController: DataCompletionDelegate, ErrorDelegate {
    func albumsDataFetched() {
        print("albumsDataFetched")
        showAnimation(rootVC: self, shouldStartAnimation: false)
        refreshControl.endRefreshing()
        collectionView.reloadData()
    }

    // MARK: Error Display

    func sendErrorInfoToUI(errMsg: String) {
        print("ErrorReceived")
        DispatchQueue.main.async {
            self.showAnimation(rootVC: self, shouldStartAnimation: false)
            self.showAlert(title: "", msg: errMsg)
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
}

// MARK: Search Delegate Methods

extension ViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            albumViewModel.filterAlbums(searchString: searchText)
        } else {
            albumViewModel.filterAlbums(searchString: "")
        }
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        view.endEditing(true)
    }

    func searchBarTextDidBeginEditing(_: UISearchBar) {
        collectionSearchBar.setShowsCancelButton(true, animated: true)
        collectionSearchBar.text = ""
    }

    func searchBarTextDidEndEditing(_: UISearchBar) {
        collectionSearchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        albumViewModel.filterAlbums(searchString: "")
        collectionSearchBar.resignFirstResponder()
        collectionSearchBar.text = "Search by album or artist"
        collectionView.reloadData()
    }
}

// MARK: CollectionView Delegates

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return albumViewModel.getAlbumCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.orange.cgColor

        cell.albumName.textColor = UIColor.white
        cell.albumName.numberOfLines = 2
        cell.albumName.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.artistName.textColor = UIColor.white
        cell.artistName.numberOfLines = 2
        cell.artistName.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.transImageView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)

        cell.albumName.text = albumViewModel.fetchAlbumName(at: indexPath.row)
        cell.artistName.text = albumViewModel.fetchArtistNmae(at: indexPath.row)

        if cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil {
            print("Cached image used, no need to download it")
            cell.albumImageView.image = cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        } else {
            let albumImage = albumViewModel.fetchAlbumImageWith(at: indexPath.row, size: ImageSize.extralarge)
            if let imageStr = albumImage {
                if let url = URL(string: imageStr) {
                    cell.albumImageView.image = UIImage(url: url)
                    self.cache.setObject(UIImage(url: url)!, forKey: (indexPath as NSIndexPath).row as AnyObject)
                } else {
                    print("URL IS NIL")
                    if let img = UIImage(data: Data()) {
                        cache?.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                    }
                }
            }
        }

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albumViewModel.fetchAlbumName(at: indexPath.row)
        let artist = albumViewModel.fetchArtistNmae(at: indexPath.row)

        print("didSelectItemAt CLICKED")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let infoController = storyboard.instantiateViewController(withIdentifier: "AlbumInfoVC") as! AlbumInfoVC
        infoController.album = album
        infoController.artist = artist
        navigationController?.pushViewController(infoController, animated: true)
    }

    // MARK: <UICollectionViewDelegateFlowLayout>

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        return CGSize(width: size, height: size)
    }

    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

}
