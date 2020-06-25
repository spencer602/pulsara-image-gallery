//
//  ThumbnailCollectionViewCell.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/24/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import UIKit

class ThumbnailCollectionViewCell: UICollectionViewCell {
    
    var id: Int!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
}
