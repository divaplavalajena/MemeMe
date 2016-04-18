//
//  DetailMemeViewController.swift
//  MemeMe
//
//  Created by Jena Grafton on 4/18/16.
//  Copyright © 2016 Bella Voce Productions. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet var memedImageView: UIImageView!
    @IBOutlet var shareButtonOutlet: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memedImageView.image = meme.imageMeme
        
        if memedImageView.image == nil {
            shareButtonOutlet.enabled = false
        } else {
            shareButtonOutlet.enabled = true
        }

    }

    
    @IBAction func shareButton(sender: AnyObject) {
        if memedImageView != nil {
            let image = memedImageView
            let controller = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
            controller.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error:NSError?) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            presentViewController(controller, animated: true, completion: nil)
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
