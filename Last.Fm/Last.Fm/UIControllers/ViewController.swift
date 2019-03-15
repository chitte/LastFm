

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, DataCompletionDelegate, ErrorDelegate {
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

    // MARK: ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        collectionSearchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self

        albumViewModel.dataDelegate = self
        albumViewModel.errDelegate = self

        collectionView.addSubview(refreshControl)

        cache = NSCache()

        // Get Album Data
        showAnimation(rootVC: self, shouldStartAnimation: true)
        albumViewModel.fetchAlbumData()

        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    }

    @objc func refreshCollectionView() {
        albumViewModel.fetchAlbumData()
    }

    // MARK: Album Data Fetched

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
            showAnimation(rootVC: self, shouldStartAnimation: false)
            showErrorDialogBox(on: self, with: errMsg)
        }
    }

    // MARK: Search Delegate Methods

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

    // MARK: CollectionView Delegates

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
            if let url = URL(string: albumImage!) {
                getImageData(from: url) { data, _, error in
                    guard let data = data, error == nil else { return }
                    // print(response?.suggestedFilename ?? url.lastPathComponent)
                    // print("Download Finished")
                    DispatchQueue.main.async {
                        let img = UIImage(data: data)
                        cell.albumImageView.image = img
                        self.cache.setObject(img!, forKey: (indexPath as NSIndexPath).row as AnyObject)
                    }
                }
            } else {
                print("URL IS NIL")
                if let img = UIImage(data: Data()) {
                    cache?.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
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
