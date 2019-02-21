//
//  GalleryViewController.swift
//  ImageUploader
//
//  Created by 1 on 14.02.19.
//  Copyright © 2019 Bogdan Magala. All rights reserved.
//

import UIKit
import Photos

public class GalleryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    public let photosFetch = PhotosFetch()
    public var selectedIndex = [Int]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let collectionViewCell = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView?.register(collectionViewCell, forCellWithReuseIdentifier: "CollectionViewCell")
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.photosFetch.grabPhotos()
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            case .notDetermined:
                print("ERROR")
            case .restricted:
                print("ERROR")
            case .denied:
                print("ERROR")
            }
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosFetch.imageArray.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let activityIndicator = cell.activityIndicator
        //MARK:-- Checking for previously selected cells
        if SingletonArrays.shared.indexArray.contains(indexPath.row) {
            activityIndicator?.isHidden = false
            activityIndicator?.startAnimating()
            cell.highlight.isHidden = false
        } else {
            activityIndicator?.isHidden = true
            activityIndicator?.stopAnimating()
            cell.highlight.isHidden = true
        }
        //Enlarging Activity Indicator
        activityIndicator?.transform = CGAffineTransform(scaleX: 3, y: 3)
        cell.imageView.image = self.photosFetch.imageArray[indexPath.row].image
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        SingletonArrays.shared.indexArray.append(indexPath.row)
        
        if CheckInternetConnection.connectionCheck() {
            cell.activityIndicator.isHidden = false
            cell.activityIndicator.startAnimating()
            cell.highlight.isHidden = false
            //MARK:-- Uploading a photo
            //Retrieving the original image through its id and resizing it
                self.photosFetch.fetchOriginalImage(with: self.photosFetch.imageArray[indexPath.row].id) { (image) in
                    //Uploading to the server
                    postImage(collectionView: collectionView, viewController: self, cell: cell, image: image, indexPath: indexPath)
                }
        } else {
            AlertController(viewController: self).showConnectionAlert()
        }
}
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.view.frame.width < self.view.frame.height {
            let width = collectionView.frame.width / 3 - 1
            return CGSize(width: width, height: width)
        } else {
            let width = collectionView.frame.width / 5 - 1
            return CGSize(width: width, height: width)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
