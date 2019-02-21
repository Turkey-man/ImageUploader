//
//  CollectionViewCell.swift
//  ImageUploader
//
//  Created by 1 on 14.02.19.
//  Copyright © 2019 Bogdan Magala. All rights reserved.
//

import UIKit

public class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var highlight: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
