//
//  ThumbnailCollectionViewController.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/24/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import UIKit

/// a class for viewing thumbnails of images
class ThumbnailCollectionViewController: UIViewController {
    
    private static let CELL_IDENTIFIER = "thumbnailCell"
    
    /// how many cells to be displayed per row
    private static let CELLS_PER_ROW: CGFloat = 3
    
    /// how many more cells to always try to show (used for infinite scrolling)
    private static let MORE_CELLS_TO_SHOW = 20
    
    /// the threshold of new cells to load before more should be loaded
    private static let THRESHOLD_TO_LOAD_MORE_CELLS = 15
    
    /// the model controller we will be using to facilitate gathering data from the Picsum API
    private let modelController = ModelController()
    
    /// keeps track of the largest id of an image that has been displayed, used for infinite scrolling
    private var hightestIDDisplayedInCV = 0
    
    /// collection view used to display the thumbnail images
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    
    
    // MARK: - View Controller Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? ImageDetailTableViewController {
            if let senderCell = sender as? ThumbnailCollectionViewCell {
                // inject the dependencies
                detailVC.modelController = modelController
                detailVC.imageID = senderCell.id
                
                // Initially set the large image view to have the thumbnail image, only until the large size
                // image loads from the network. Even though we are calling fetch here, the thumbnail should
                // actually already be in the modelController's cache, assuming the cache setting is turned on.
                modelController.fetchThumbnailImage(with: senderCell.id) { image in
                    detailVC.image = image
                }
                
                // fetch the image info. Do this before fetching the large size image, because image info should load quicker
                modelController.fetchImageInfo(with: senderCell.id) { imageID, author, width, height, imageURL, downloadURL in
                    // detailVC.imageID = imageID // we set the id using the senderCell, so we don't have to use the fetched id
                    detailVC.author = author
                    detailVC.imageWidth = width
                    detailVC.imageHeight = height
                    detailVC.imageURL = imageURL
                    detailVC.downloadURL = downloadURL
                }
                
                // fetch the large size image
                modelController.fetchLargeSizeImage(with: senderCell.id) { image in
                    detailVC.image = image
                }
            }
        }
    }
}

extension ThumbnailCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Collection View Delegate and DataSource Methods
    
    // size the cells accordingly
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/Self.CELLS_PER_ROW, height: collectionView.bounds.width/Self.CELLS_PER_ROW)
    }
    
    // rows in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // setting this to always try to show more cells than have been displayed ensures a nice infinte scrolling feel
        return hightestIDDisplayedInCV + Self.MORE_CELLS_TO_SHOW
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.CELL_IDENTIFIER, for: indexPath)
        if let thumbCell = cell as? ThumbnailCollectionViewCell {
            // clear the image, so as not to display a previous image while the new image is loading
            thumbCell.imageView.image = nil
            thumbCell.spinner.startAnimating()
            thumbCell.id = indexPath.item
            
            // fetch the thumbnail image
            modelController.fetchThumbnailImage(with: indexPath.item) { image in
                if thumbCell.id == indexPath.item {
                    DispatchQueue.main.async {
                        // setting this threshold higher keeps from wasting too much resources on fetching new data
                        if indexPath.item >= self.hightestIDDisplayedInCV + Self.THRESHOLD_TO_LOAD_MORE_CELLS {
                            // update the value of the hightest id that has been displayed
                            // then we must reload the data to ensure CV.numberOfItemsInSection is called
                            self.hightestIDDisplayedInCV = indexPath.item
                            collectionView.reloadData()
                        }
                        // set the image and stop the spinner
                        thumbCell.imageView.image = image
                        thumbCell.spinner.stopAnimating()
                    }
                }
            }
        }
        return cell
    }
}
