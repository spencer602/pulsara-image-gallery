//
//  ImageDetailTableViewController.swift
//  Pulsara Image Gallery
//
//  Created by Spencer DeBuf on 6/25/20.
//  Copyright © 2020 Spencer DeBuf. All rights reserved.
//

import UIKit

class ImageDetailTableViewController: UITableViewController {

    var image: UIImage? { didSet { DispatchQueue.main.async {
        self.imageView?.image = self.image
        } } }
    
    var author: String? { didSet { DispatchQueue.main.async {
        self.authorLabel?.text = "Author: \(self.author ?? "No Author Data")"
        } } }
    
    var imageID: Int?
    var imageWidth: Int?
    var imageHeight: Int?
    var imageURL: String?
    var downloadURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        
        authorLabel.text = "Author: \(author ?? "No Author Data")"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    @IBOutlet var detailTableView: UITableView!
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return tableView.frame.width }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    @IBOutlet weak var imageViewCell: UITableViewCell!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
