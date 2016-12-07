//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Jena Grafton on 4/14/16.
//  Copyright © 2016 Bella Voce Productions. All rights reserved.
//

import Foundation
import UIKit
import CoreData


private let reuseIdentifier = "CustomMemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
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
        return fetchedResultsController
        
    }()

    
    //outlet to flowLayout
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        
        do{
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error fetching from Core Data on SentMemesCollectionViewController")
        }
        
        collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        //implement cell flowLayout
        cellFlowLayout(self.view.frame.size)
    }

    func cellFlowLayout(_ size: CGSize) {
        print("cellFlowLayout called")
        let space: CGFloat = 1.5
        let dimension: CGFloat = size.width >= size.height ? (size.width - (5 * space)) / 6.0 : (size.width - (2 * space)) / 3.0
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    /*
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("viewWillTransitionToSize method called")
        cellFlowLayout(size)
    }
    */
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return fetchedResultsController.sections![section].numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomMemeCollectionViewCell

        let meme = fetchedResultsController.object(at: indexPath) as! Meme
        //cell.setText(meme.topText, bottomString: meme.bottomText)
        
        cell.sentMemeImageView?.image = UIImage(data:meme.imageMeme as Data)
        
        //let imageView = UIImageView(image: meme.imageMeme)
        //cell.backgroundView = imageView
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // If a meme is selected in the collection view navigate to the detailMemeViewController to display the meme
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailMemeViewController") as! DetailMemeViewController
        detailController.meme = fetchedResultsController.object(at: indexPath) as! Meme
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    

    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
