

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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        collectionSearchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        albumViewModel.delegate = self

        // Get Album Data
        albumViewModel.fetchAlbumData()
    }

    func albumsDataFetched() {
        print("albumsDataFetched")
        self.collectionView.reloadData()
    }

    // MARK: Search

    func searchBar(_: UISearchBar, textDidChange _: String) {
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
        collectionSearchBar.resignFirstResponder()
        collectionSearchBar.text = ""
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

        cell.albumName.text = albumViewModel.fetchAlbumName(index: indexPath.row)
        cell.artistName.text = albumViewModel.fetchArtistNmae(index: indexPath.row)

        let albumImage = albumViewModel.fetchAlbumImageWith(index: indexPath.row, size: ImageSize.extralarge)
        if let url = URL(string: albumImage!) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    cell.albumImageView.image = UIImage(data: data)
                }
            }
        } else {
            print("URL IS NIL")
        }

        return cell
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
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
