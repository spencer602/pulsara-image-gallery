//
//  ModelController.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/24/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import Foundation
import UIKit

class ModelController {
    private let dataRetriever = DataRetriever()
    
    private var cacheThumbnails = true
    
    var thumbnails = [Int: UIImage]()
//    var fullImages = [Int: UIImage]()
    
    var thumbnailSize: (width: Int, height: Int) {
        didSet {
            thumbnails.removeAll()
        }
    }
    
    var fullImageSize: (width: Int, height: Int)
    
    init(thumbWidth: Int, thumbHeight: Int, fullWidth: Int, fullHeight: Int) {
        thumbnailSize.width = thumbWidth
        thumbnailSize.height = thumbHeight
        fullImageSize.width = fullWidth
        fullImageSize.height = fullHeight
    }
    
    func fetchThumbnailImage(with id: Int, _ completionClosure: @escaping (UIImage) -> Void) {
        if let cached = thumbnails[id] {
            completionClosure(cached)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = self.dataRetriever.getImage(with: id, width: self.thumbnailSize.width, height: self.thumbnailSize.height) {
                    if self.cacheThumbnails { self.thumbnails[id] = image }
                    completionClosure(image)
                }
            }
        }
    }
    
    func fetchFullSizeImage(with id: Int, _ completionClosure: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = self.dataRetriever.getImage(with: id, width: self.fullImageSize.width, height: self.fullImageSize.height) {
                if self.cacheThumbnails { self.thumbnails[id] = image }
                completionClosure(image)
            }
        }
    }
    
    func fetchImageInfo(with id: Int, _ completionClosure: @escaping (Int?, String?, Int?, Int?, String?, String?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.dataRetriever.fetchImageInfo(with: id) { imageID, author, width, height, imageURL, downloadURL in
                completionClosure(imageID, author, width, height, imageURL, downloadURL)
            }
        }
    }
}
