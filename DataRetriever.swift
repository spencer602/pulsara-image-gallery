//
//  DataRetriever.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/24/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import Foundation
import UIKit

class DataRetriever {
    
    func getImage(with id: Int, width: Int, height: Int) -> UIImage? {
        let urlPath: String = "https://picsum.photos/id/\(id)/\(width)/\(height).jpg"
        if let url: URL = URL(string: urlPath) {
            print("url success")
            if let data = try? Data(contentsOf: url) {
                print("data success")
                if let image = UIImage(data: data) {
                    print("success")
                    return image
                }
                
            }
        }
        print("some error")
        return nil
    }
}
