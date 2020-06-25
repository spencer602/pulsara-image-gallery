//
//  ImageZoomerViewController.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/25/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import UIKit

class ImageZoomerViewController: UIViewController {

    var image: UIImage? { didSet { DispatchQueue.main.async {
        self.imageView?.image = self.image
    } } }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        imageView.image = image
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ImageZoomerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
