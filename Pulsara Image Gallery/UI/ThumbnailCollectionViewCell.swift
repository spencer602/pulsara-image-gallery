//
//  ThumbnailCollectionViewCell.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/24/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import UIKit

/// a custom CollectionViewCell to display thumbnails, activity spinners, and keep track of the image id
class ThumbnailCollectionViewCell: UICollectionViewCell {
    
    /// image id
    var id: Int!
    
    // outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
}
