//
//  ImageZoomerViewController.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/25/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import UIKit

/// a class for viewing a full resolution version of the image with zoom and pan functionality
class ImageZoomerViewController: UIViewController {

    // outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    /// the image we will display, when set, update the imageView outlet
    var image: UIImage? { didSet { DispatchQueue.main.async {
        self.imageView?.image = self.image
        self.spinner?.stopAnimating()
    } } }
    
    // MARK: - View Controller Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 15.0
        
        // set the image in the case where the image var was set, but the outlet was still nil,
        // so the outlet wasn't updated. Here the outlets are guaranteed to not be nil
        imageView.image = image
        
        // show that there is loading activity if the image is still nil
        image == nil ? spinner.startAnimating() : spinner.stopAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // if the device flips orientation, the frames of the scrollView and imageView need reset
        scrollView.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height)
        imageView.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height)

    }
}

extension ImageZoomerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
