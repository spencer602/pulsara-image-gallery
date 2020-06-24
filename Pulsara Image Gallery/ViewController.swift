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
    
    let dataretriver = DataRetriever()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
//        swipe.direction = .left
//        view.addGestureRecognizer(swipe)
        
        displayImage(with: currentID)
    }
    
    func displayImage(with id: Int) {
        let image = dataretriver.getImage(with: id, width: 200, height: 200)
        imageView.image = image
    }

//    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
//        print("entered handle swipe")
//        switch sender.state {
//        case .ended:
//            print("case endede")
//            switch sender.direction {
//            case .left:
//                print("case left")
//                currentID += 1
//                displayImage(with: currentID)
//            default: break
//            }
//        default: break
//        }
//    }
    
}

