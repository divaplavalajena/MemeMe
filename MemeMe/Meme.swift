//
//  Meme.swift
//  MemeMe
//
//  Created by Jena Grafton on 12/7/16.
//  Copyright © 2016 Bella Voce Productions. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//@objc(Meme)
class Meme: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meme> {
        return NSFetchRequest<Meme>(entityName: "Meme");
    }
    
    @NSManaged var topText: String
    @NSManaged var bottomText: String
    @NSManaged var imageOriginal: Data
    @NSManaged var imageMeme: Data
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?){
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Meme", in: context)!
        super.init(entity: entity, insertInto: context)
        
        // Dictionary
        bottomText = dictionary["bottomText"] as! String
        topText = dictionary["topText"] as! String
        
        imageOriginal = UIImageJPEGRepresentation(dictionary["orgImage"] as! UIImage, 1)!
        imageMeme = UIImageJPEGRepresentation(dictionary["memedImage"] as! UIImage, 1)!
        
    }

    
}
