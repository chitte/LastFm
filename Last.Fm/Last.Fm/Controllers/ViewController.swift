//
//  ViewController.swift
//  Last.Fm
//
//  Created by Onyx on 14/03/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet var collectionSearchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!

    var cellIdentifier = "Cell"
    var numberOfItemsPerRow: Int = 2
    var cellWidth: CGFloat {
        return collectionView.frame.width / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        collectionSearchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }


    // MARK: Search

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.collectionSearchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.collectionSearchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.collectionSearchBar.resignFirstResponder()
        self.collectionSearchBar.text = ""
    }

    // MARK: CollectionView

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
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
        cell.transImageView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)

        cell.albumName.text = "Album Name"
        cell.artistName.text = "Artist Name"
        return cell
    }

    // MARK: <UICollectionViewDelegateFlowLayout>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

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

