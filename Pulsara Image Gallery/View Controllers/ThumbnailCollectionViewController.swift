//
//  ThumbnailCollectionViewController.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/24/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import UIKit

class ThumbnailCollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    private var hightestIDDisplayedInCV = 0
    
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    
    let modelController = ModelController(thumbWidth: 150, thumbHeight: 150, fullWidth: 600, fullHeight: 600)
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? ImageDetailTableViewController {
            if let senderCell = sender as? ThumbnailCollectionViewCell {
                
                detailVC.imageID = senderCell.id
                
                modelController.fetchThumbnailImage(with: senderCell.id) { image in
                    detailVC.image = image
                }
                
                modelController.fetchImageInfo(with: senderCell.id) { imageID, author, width, height, imageURL, downloadURL in
                    // detailVC.imageID = imageID
                    detailVC.author = author
                    detailVC.imageWidth = width
                    detailVC.imageHeight = height
                    detailVC.imageURL = imageURL
                    detailVC.downloadURL = downloadURL
                }
                
                modelController.fetchFullSizeImage(with: senderCell.id) { image in
                    detailVC.image = image
                }
            }
        }
    }
}

extension ThumbnailCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.1, height: collectionView.frame.width/3.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hightestIDDisplayedInCV + 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath)
        if let thumbCell = cell as? ThumbnailCollectionViewCell {
            thumbCell.imageView.image = nil
            thumbCell.spinner.startAnimating()
            thumbCell.id = indexPath.item
            
            modelController.fetchThumbnailImage(with: indexPath.item) { image in
                if thumbCell.id == indexPath.item {
                    DispatchQueue.main.async {
                        if indexPath.item >= self.hightestIDDisplayedInCV + 15 {
                            self.hightestIDDisplayedInCV = indexPath.item
                            collectionView.reloadData()
                        }
                        thumbCell.imageView.image = image
                        thumbCell.spinner.stopAnimating()
                    }
                }
            }
        }
        return cell
    }
}
