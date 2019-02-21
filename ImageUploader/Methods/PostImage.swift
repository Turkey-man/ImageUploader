//
//  PostImage.swift
//  ImageUploader
//
//  Created by 1 on 18.02.19.
//  Copyright © 2019 Bogdan Magala. All rights reserved.
//

import UIKit
import Alamofire

public func postImage(collectionView: UICollectionView, viewController: UIViewController, cell: CollectionViewCell, image: UIImage, indexPath: IndexPath) {
    let clientID = "99d6013c99a276c"
    let authorizationToken = "3404548f592e92b59ac3fa4e46548745d0ba6e34"
    let username = "Falloutzadrot"
    let url = "https://api.imgur.com/3/upload"
    let imageData = UIImagePNGRepresentation(image)
    let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
    let parameters = ["image": base64Image]
    let conf = URLSessionConfiguration.default
    conf.httpMaximumConnectionsPerHost = 1
    //MARK:-- Uploading image to server
    //This method jumps to any other thread no matter what
    upload(multipartFormData: { multipartFormData in
        if let imageData = UIImageJPEGRepresentation(image, 1) {
            multipartFormData.append(imageData, withName: username, fileName: "\(username).png", mimeType: "image/png")
        }
        
        for (key, value) in parameters {
            multipartFormData.append((value?.data(using: .utf8))!, withName: key)
        }}, to: url, method: .post, headers: ["Authorization": "Bearer \(authorizationToken)",
                                              "ClientID": clientID],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.response { response in
                        let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                        let imageDic = json?["data"] as? [String: Any]  
                        //MARK:-- Checking for error
                        if imageDic?["link"] == nil {
                            cell.activityIndicator.isHidden = true
                            cell.activityIndicator.stopAnimating()
                            cell.highlight.isHidden = true
                            SingletonArrays.shared.indexArray.remove(at: SingletonArrays.shared.indexArray.index(of: indexPath.row)!)
                            AlertController(viewController: viewController).showAlert()
                        } else {
                        let imageLink = imageDic?["link"] as! String
                        CoreDataMethods(viewController: viewController).saveLink(imageLink: imageLink)
                        cell.activityIndicator.isHidden = true
                        cell.activityIndicator.stopAnimating()
                        cell.highlight.isHidden = true
                        SingletonArrays.shared.indexArray.remove(at: SingletonArrays.shared.indexArray.index(of: indexPath.row)!)
                        }
                    }
                case .failure(let encodingError):
                    AlertController(viewController: viewController).showAlert()
                    print("error:\(encodingError)")
                }
    })
}
