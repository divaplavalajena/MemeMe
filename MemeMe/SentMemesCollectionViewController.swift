//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Jena Grafton on 4/14/16.
//  Copyright © 2016 Bella Voce Productions. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CustomMemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    //outlet to flowLayout
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        //implement cell flowLayout
        cellFlowLayout()
    }

    func cellFlowLayout() {
        let space: CGFloat = 3.0
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 2.0
        let dimensionHeight = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 1.0
        flowLayout.itemSize = CGSizeMake(dimensionWidth, dimensionHeight)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CustomMemeCollectionViewCell

        let meme = memes[indexPath.item]
        //cell.setText(meme.topText, bottomString: meme.bottomText)
        
        cell.sentMemeImageView?.image = meme.imageMeme
        
        //let imageView = UIImageView(image: meme.imageMeme)
        //cell.backgroundView = imageView
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // If a meme is selected in the collection view navigate to the detailMemeViewController to display the meme
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailMemeViewController") as! DetailMemeViewController
        detailController.meme = self.memes[indexPath.row]
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
