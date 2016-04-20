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

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memedImageView.image = meme.imageMeme

    }

    
}
