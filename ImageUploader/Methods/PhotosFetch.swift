//
//  PhotosFetch.swift
//  ImageUploader
//
//  Created by 1 on 16.02.19.
//  Copyright © 2019 Bogdan Magala. All rights reserved.
//

import Photos

public class CellPhoto {
    public let image: UIImage
    public let id: String
    
    init(image: UIImage, id: String) {
        self.image = image
        self.id = id
    }
}

func scaleUIImageToSize(image: UIImage, size: CGSize) -> UIImage {
    let hasAlpha = false
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.draw(in: CGRect(origin: .zero, size: size))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage!
}

public class PhotosFetch {
    public var imageArray = [CellPhoto]()
    //MARK:-- Getting the array of preview images
    public func grabPhotos() {
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .fastFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        //Cheching if the device gallery actually has images
            if fetchResult.count > 0 {
                for item in 0..<fetchResult.count {
                    let object = fetchResult.object(at: item)
                    imgManager.requestImage(for: fetchResult.object(at: item),
                                            targetSize: CGSize(width: 80, height: 80) ,
                                            contentMode: PHImageContentMode.aspectFill,
                                            options: requestOptions,
                                            resultHandler: {
                                                image, error in
                                                self.imageArray.append(CellPhoto(image: image!,
                                                                                 id: object.localIdentifier))
                    })
                }
            }
    }
    //MARK:-- Getting resized originals for uploading
    public func fetchOriginalImage(with id: String, competition: @escaping ((UIImage) -> ()) ) {
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .fastFormat
        let fetchOptions = PHFetchOptions()
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: fetchOptions)
        //Cheching if the device gallery actually has images and accessing the original through its ID
            if fetchResult.count > 0 {
                    imgManager.requestImage(for: fetchResult.object(at: 0),
                                            targetSize:  PHImageManagerMaximumSize,
                                            contentMode: PHImageContentMode.aspectFit,
                                            options: requestOptions,
                                            resultHandler: {
                                                image, error in
                                                let scaledImage = image
                                                let scaledWidth = (scaledImage?.size.width)!*0.2
                                                let scaledHeight = (scaledImage?.size.height)!*0.2
                                                let newSize = CGSize(width: scaledWidth, height: scaledHeight)
                                                competition(scaleUIImageToSize(image: image!, size: newSize))
                    })
            }
    }
}
