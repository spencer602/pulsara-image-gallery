//
//  DataRetriever.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/24/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import Foundation
import UIKit

/// A class for downloading data from the Picsum API
class DataRetriever {
    
    func getImage(with id: Int, width: Int, height: Int) -> UIImage? {
        let urlPath: String = "https://picsum.photos/id/\(id)/\(width)/\(height).jpg"
        if let url: URL = URL(string: urlPath) {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    return image
                }
            }
        }
        print("some error")
        return nil
    }
    
    func fetchImageInfo(with id: Int, completionClosure: @escaping (Int?, String?, Int?, Int?, String?, String?) -> Void ) {
        let urlPath: String = "https://picsum.photos/id/\(id)/info"
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

        // the task of downloading the data, and a completion handler to handle the data
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            var imageID: Int?
            var author: String?
            var width: Int?
            var height: Int?
            var imageURL: String?
            var downloadURL: String?
            
            if error != nil {
                print("Failed to download data")
            } else {
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary

                // retrieve the location name from the json data
                imageID = jsonResult["id"] as? Int
                author = jsonResult["author"] as? String
                width = jsonResult["width"] as? Int
                height = jsonResult["height"] as? Int
                imageURL = jsonResult["url"] as? String
                downloadURL = jsonResult["download_url"] as? String
            }
            
            completionClosure(imageID, author, width, height, imageURL, downloadURL)
        }
        task.resume()
    }
}
