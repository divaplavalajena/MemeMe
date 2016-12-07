//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Jena Grafton on 4/14/16.
//  Copyright © 2016 Bella Voce Productions. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SentMemesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    /*
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    */
    
    lazy var sharedContext: NSManagedObjectContext = {
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        return stack.context
    }()
    
    // MARK: NSFetchedResultsController
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Meme.fetchRequest()
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationTime", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.sharedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        do{
            try fetchedResultsController.performFetch()
        }catch{
            var error = error as Error
            print("There was an error fetching from Core Data on SentMemesTableViewController")
            print("Unresolved error \(error), \(error.localizedDescription)")
        }

        
        return fetchedResultsController
        
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchedResultsController.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print("There was an error fetching from Core Data on SentMemesTableViewController")
        }
        */
        
        tableView.reloadData()
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return fetchedResultsController.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)

        let meme = fetchedResultsController.object(at: indexPath) as! Meme
        
        // Set the top meme text and image
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = UIImage(data:meme.imageMeme as Data)
        
        //And the detail text label for the bottom half of the meme text
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomText
        }


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If a meme is selected in the table view navigate to the detailMemeViewController to display the meme
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailMemeViewController") as! DetailMemeViewController
        detailController.meme = fetchedResultsController.object(at: indexPath) as! Meme
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
