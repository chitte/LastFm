

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, DataCompletionDelegate {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        collectionSearchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        albumViewModel.delegate = self

        collectionView.addSubview(refreshControl)

        self.cache = NSCache()

        // Get Album Data
        albumViewModel.fetchAlbumData()

        self.refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    }

    @objc func refreshCollectionView() {
        albumViewModel.fetchAlbumData()
    }

    func albumsDataFetched() {
        print("albumsDataFetched")
        self.refreshControl.endRefreshing()
        self.collectionView.reloadData()
    }

    // MARK: Search

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count > 0) {
            albumViewModel.filterAlbums(searchString: searchText)
        }
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        view.endEditing(true)
    }

    func searchBarTextDidBeginEditing(_: UISearchBar) {
        collectionSearchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_: UISearchBar) {
        collectionSearchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        albumViewModel.filterAlbums(searchString: "")

        collectionSearchBar.resignFirstResponder()
        collectionSearchBar.text = ""
        collectionView.reloadData()
    }

    // MARK: CollectionView

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

        cell.albumName.text = albumViewModel.fetchAlbumName(in: indexPath.row)
        cell.artistName.text = albumViewModel.fetchArtistNmae(in: indexPath.row)

        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
            print("Cached image used, no need to download it")
            cell.albumImageView.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        } else {
            let albumImage = albumViewModel.fetchAlbumImageWith(in: indexPath.row, size: ImageSize.extralarge)
            if let url = URL(string: albumImage!) {
                getImageData(from: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    // print(response?.suggestedFilename ?? url.lastPathComponent)
                    // print("Download Finished")
                    DispatchQueue.main.async() {
                        let img = UIImage(data: data)
                        cell.albumImageView.image = img
                        self.cache.setObject(img!, forKey: (indexPath as NSIndexPath).row as AnyObject)
                    }
                }
            } else {
                print("URL IS NIL")
                if let img = UIImage(data: Data()) {
                    self.cache?.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                }
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albumViewModel.fetchAlbumName(in: indexPath.row)
        let artist = albumViewModel.fetchArtistNmae(in: indexPath.row)

        albumViewModel.fetchAlbumInformation(artist: artist, album: album)
    }

    func albumsInformationFetched() {
        print("albumsInformationFetched")
    }

    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
