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
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    
    let modelController = ModelController(thumbWidth: 200, thumbHeight: 200, fullWidth: 600, fullHeight: 600)
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ThumbnailCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.1, height: collectionView.frame.width/3.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
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
                        thumbCell.imageView.image = image
                        thumbCell.spinner.stopAnimating()
                    }
                }
            }
            
            
        }
        return cell
    }
    
    
}
