//
//  ImageDetailTableViewController.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/25/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import UIKit

class ImageDetailTableViewController: UITableViewController {

    var modelController: ModelController!
    
    var image: UIImage? { didSet { DispatchQueue.main.async {
        self.imageView?.image = self.image
    } } }
    
    var author: String? { didSet { DispatchQueue.main.async {
        self.authorLabel?.text = "Author: \(self.author ?? "No Author Data")"
    } } }
    
    var imageID: Int? { didSet { DispatchQueue.main.async {
        let stringData = self.imageID == nil ? "No ID Data" : "\(self.imageID!)"
        self.IDLabel?.text = "ID: \(stringData)"
    } } }
    
    var imageWidth: Int? { didSet { DispatchQueue.main.async {
        self.dimensionsLabel?.text = self.dimensionsString
    } } }
    
    var imageHeight: Int? { didSet { DispatchQueue.main.async {
        self.dimensionsLabel?.text = self.dimensionsString
    } } }
    
    var dimensionsString: String {
        var dimString = "Dimensions: "
        if let width = imageWidth, let height = imageHeight {
            dimString += "\(width)x\(height)"
        } else { dimString += "No Dimension Data" }
        
        return dimString
    }
    
    private var zoomerImage: UIImage?
    
    var imageURL: String?
    var downloadURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        
        authorLabel.text = "Author: \(author ?? "No Author Data")"
        
        let stringData = imageID == nil ? "No ID Data" : "\(imageID!)"
        IDLabel.text = "ID: \(stringData)"
        
        if let id = imageID {
            modelController.fetchImageNativeSize(with: id) { image in
                self.zoomerImage = image
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return tableView.frame.width }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var dimensionsLabel: UILabel!
    
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let zoomerVC = segue.destination as? ImageZoomerViewController {
            if let imageCell = sender as? UITableViewCell {
                if let id = imageID {
                    if let zoom = zoomerImage { zoomerVC.image = zoom }
                    else {
                        modelController.fetchImageNativeSize(with: id) { image in
                            zoomerVC.image = image
                        }
                    }
                }
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
