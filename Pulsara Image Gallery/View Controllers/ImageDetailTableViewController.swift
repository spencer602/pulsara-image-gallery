//
//  ImageDetailTableViewController.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/25/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import UIKit

/// a class for viewing a larger version of the image, as well as associated info for the image
class ImageDetailTableViewController: UITableViewController {
    
    // outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var dimensionsLabel: UILabel!

    /// the modelContoller we use for getting our data, THIS MUST BE SET IN prepareForSegue!
    var modelController: ModelController!
    
    /// the image we will display, when set, update the imageView outlet
    var image: UIImage? { didSet { DispatchQueue.main.async {
        self.imageView?.image = self.image
    } } }
    
    /// the author of the image, when set, update the authorLabel outlet
    var author: String? { didSet { DispatchQueue.main.async {
        self.authorLabel?.text = "Author: \(self.author ?? "No Author Data")"
    } } }
    
    /// the image id, when set, update the idLabel outlet
    var imageID: Int? { didSet { DispatchQueue.main.async {
        let stringData = self.imageID == nil ? "No ID Data" : "\(self.imageID!)"
        self.IDLabel?.text = "ID: \(stringData)"
    } } }
    
    /// the image width, when set, reset the label's text to the computed property dimensionsString
    var imageWidth: Int? { didSet { DispatchQueue.main.async {
        self.dimensionsLabel?.text = self.dimensionsString
    } } }
    
    /// the image height, when set, reset the label's text to the computed property dimensionsString
    var imageHeight: Int? { didSet { DispatchQueue.main.async {
        self.dimensionsLabel?.text = self.dimensionsString
    } } }
    
    /// formats the dimensions string using imageWidth and imageHeight
    var dimensionsString: String {
        var dimString = "Dimensions: "
        if let width = imageWidth, let height = imageHeight {
            dimString += "\(width)x\(height)"
        } else { dimString += "No Dimension Data" }
        
        return dimString
    }
    
    // this is used to start loading the full resolution image preemptively, in case we segue to ZoomerVC
    /// the full, native resolution image
    private var zoomerImage: UIImage?
    
    // currently unused, we aren't using the urls, but they are fetched as part of the info fetch
    var imageURL: String?
    var downloadURL: String?
    
    // MARK: - View Controller Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the image and labels, in the case where the vars were set, but the outlets were still nil,
        // so the outlets weren't updated. Here the outlets are guaranteed to not be nil
        imageView.image = image
        authorLabel.text = "Author: \(author ?? "No Author Data")"
        
        let stringData = imageID == nil ? "No ID Data" : "\(imageID!)"
        IDLabel.text = "ID: \(stringData)"
        
        // here we start fetching the full size image in case we segue to the ZoomerVC
        if let id = imageID {
            modelController.fetchImageNativeSize(with: id) { image in
                self.zoomerImage = image
            }
        }
    }
    
    // MARK: - Table View Methods
        
    // used to make sure the large image view is square
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return tableView.frame.width }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let zoomerVC = segue.destination as? ImageZoomerViewController {
            if let _ = sender as? UITableViewCell {
                if let id = imageID {
                    // if we have already loaded the full size image, we dont need to fetch and wait
                    if let zoom = zoomerImage { zoomerVC.image = zoom }
                    // if we haven't already loaded the full size image, we need to fetch it
                    else {
                        modelController.fetchImageNativeSize(with: id) { image in
                            zoomerVC.image = image
                        }
                    }
                }
            }
        }
    }
}
