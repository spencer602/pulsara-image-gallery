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
    
    /**
     fetches a specific image from the Picsum API
     
     - Parameter id: the identifier representing the desired image
     - Parameter width: the requested width of the image
     - Parameter height: the requested height of the image
     
     - Returns: the requested image, or nil if there was an error fetching the image
    */
    func getImage(with id: Int, width: Int, height: Int) -> UIImage? {
        let urlPath: String = "https://picsum.photos/id/\(id)/\(width)/\(height).jpg"
        if let url: URL = URL(string: urlPath) {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    return image
                } else { print("Error creating image from data in DataRetriever.getImage()") }
            } else { print("Error creating data in DataRetriever.getImage()") }
        } else { print("Error creating URL in DataRetriever.getImage()") }

        return nil
    }
    
    /**
     fetches the info associated with a specific image from the Picsum API
     
     - Parameter id: the identifier representing the desired image
     - Parameter completionClosure: the closure to execute after attempting to fetch the data; use this to assign the fetched data asynchronously
     */
    func fetchImageInfo(with id: Int, completionClosure: @escaping (Int?, String?, Int?, Int?, String?, String?) -> Void ) {
        let urlPath: String = "https://picsum.photos/id/\(id)/info"
        if let url: URL = URL(string: urlPath) {
            let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

            // the task of downloading the data, and a completion handler to handle the data
            let task = defaultSession.dataTask(with: url) { (data, response, error) in
                var imageID: Int?
                var author: String?
                var width: Int?
                var height: Int?
                var imageURL: String?
                var downloadURL: String?
                
                if error != nil { print("Error in DataRetriever.fetchImageInfo(), dataTask error") }
                else {
                    if let data = data {
                        if let jsonResult = try? JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) {
                            if let jsonDict = jsonResult as? NSDictionary {
                                // retrieve the  from the json data
                                imageID = jsonDict["id"] as? Int
                                author = jsonDict["author"] as? String
                                width = jsonDict["width"] as? Int
                                height = jsonDict["height"] as? Int
                                imageURL = jsonDict["url"] as? String
                                downloadURL = jsonDict["download_url"] as? String
                            } else { print("Error in DataRetriever.fetchImageInfo(), jsonResult could not be cast to NSDictionary") }
                        } else { print("Error in DataRetriever.fetchImageInfo(), failed to get json object from data")}
                    } else { print("Error in DataRetriever.fetchImageInfo(), data was nil") }
                }
                
                completionClosure(imageID, author, width, height, imageURL, downloadURL)
            }
            task.resume()
        } else { print("Error in DataRetriever.fetchImageInfo(), failed to create URL")}
    }
}
