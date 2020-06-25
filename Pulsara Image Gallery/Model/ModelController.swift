//
//  ModelController.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/24/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import Foundation
import UIKit

/// A class for interfacing with the Picsum API
class ModelController {
    
    /// the DataRetriever for handling network calls to the Picsum API
    private let dataRetriever = DataRetriever()
    
    /// If this is set to true, the app will cache the thumbnail images in memory making subsequent fetches of the same thumbail more efficient in speed and data usage. If memory usage is an issue, this should be set to false
    private var cacheThumbnails = true
    
    /// the cache of thumbnail images that have already been fetched
    var thumbnails = [Int: UIImage]()
    
    /// the size of the thumbnails, note that changing this value clears the cached thumnail images
    var thumbnailSize: (width: Int, height: Int) {
        didSet {
            thumbnails.removeAll()
        }
    }
    
    /// the size of the 'large' image size
    var largeImageSize: (width: Int, height: Int)
    
    /**
     initializes an instance of ModelController with the specified defualt thumbnail and large size

     - Parameter thumbWidth: the preferred thumbnail width
     - Parameter thumbHeight: the preferred thumbnail height
     - Parameter largeWidth: the preferred large width
     - Parameter largeHeight: the preferred thumbnail height
     */
    init(thumbWidth: Int, thumbHeight: Int, largeWidth: Int, largeHeight: Int) {
        thumbnailSize.width = thumbWidth
        thumbnailSize.height = thumbHeight
        largeImageSize.width = largeWidth
        largeImageSize.height = largeHeight
    }
    
    /**
     attempts to fetch the image with the given identifier, in the default thumbnail size
     
     - Parameter id: the id for the requested image
     - Parameter completionClosure: the closure to execute after attempting to fetch the image; use this to assign the fetched image asynchronously
     */
    func fetchThumbnailImage(with id: Int, _ completionClosure: @escaping (UIImage) -> Void) {
        // if we have the image cached, pull it from the cache
        if let cached = thumbnails[id] { completionClosure(cached) } else {
            fetchImage(with: id, width: thumbnailSize.width, height: thumbnailSize.height) { image in
                // if the current settings are to cache the images, this is where we add the image to the cache(dictionary)
                if self.cacheThumbnails { self.thumbnails[id] = image }
                completionClosure(image)
            }
        }
    }
    
    /**
    attempts to fetch the image with the given identifier, in the default 'large' image size
    
    - Parameter id: the id for the requested image
    - Parameter completionClosure: the closure to execute after attempting to fetch the image; use this to assign the fetched image asynchronously
    */
    func fetchLargeSizeImage(with id: Int, _ completionClosure: @escaping (UIImage) -> Void) {
        fetchImage(with: id, width: largeImageSize.width, height: largeImageSize.height, completionClosure)
    }
    
    /**
    attempts to fetch the image info with the given identifier
    
    - Parameter id: the id for the requested image info
    - Parameter completionClosure: the closure to execute after attempting to fetch the image info; use this to assign the fetched image info asynchronously
    */
    func fetchImageInfo(with id: Int, _ completionClosure: @escaping (Int?, String?, Int?, Int?, String?, String?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.dataRetriever.fetchImageInfo(with: id) { imageID, author, width, height, imageURL, downloadURL in
                completionClosure(imageID, author, width, height, imageURL, downloadURL)
            }
        }
    }
    
    /**
    attempts to fetch the image with the given identifier, in the native image size
    
    - Parameter id: the id for the requested image
    - Parameter completionClosure: the closure to execute after attempting to fetch the image; use this to assign the fetched image asynchronously
    */
    func fetchImageNativeSize(with id: Int, _ completionClosure: @escaping (UIImage) -> Void ) {
        var nativeHeight = 0
        var nativeWidth = 0
        
        fetchImageInfo(with: id) { _, _, width, height, _, _  in
            nativeWidth = width ?? nativeWidth
            nativeHeight = height ?? nativeHeight
            self.fetchImage(with: id, width: nativeWidth, height: nativeHeight, completionClosure)
        }
    }
    
    /**
    attempts to fetch the image with the given identifier, with the given size
    
    - Parameter id: the id for the requested image
    - Parameter width: the desired width of the image
    - Parameter height: the desired height of the image
    - Parameter completionClosure: the closure to execute after attempting to fetch the image; use this to assign the fetched image asynchronously
    */
    private func fetchImage(with id: Int, width: Int, height: Int, _ completionClosure: @escaping (UIImage) -> Void ) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = self.dataRetriever.getImage(with: id, width: width, height: height) {
                completionClosure(image)
            }
        }
    }
}
