//
//  ViewController.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/24/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var currentID = 0
    let modelController = ModelController(thumbWidth: 200, thumbHeight: 200, fullWidth: 600, fullHeight: 600)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipe.direction = .left
        view.addGestureRecognizer(swipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
//
        displayImage(with: currentID)
    }
    
    func displayImage(with id: Int) {
        modelController.fetchThumbnailImage(with: id) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
//        let image = dataretriver.getImage(with: id, width: 200, height: 200)
//        imageView.image = image
    }

    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        print("entered handle swipe")
        switch sender.state {
        case .ended:
            print("case endede")
            switch sender.direction {
            case .left:
                print("case left")
                currentID += 1
                displayImage(with: currentID)
            case .right:
                print("case right")
                currentID -= 1
                displayImage(with: currentID)
            default: break
            }
        default: break
        }
    }
    
}

