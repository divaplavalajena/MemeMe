//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Jena Grafton on 4/6/16.
//  Copyright © 2016 Bella Voce Productions. All rights reserved.
//

import UIKit


class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var memedImage: UIImage?
    
    @IBOutlet var instructionLabel: UILabel!
    
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    
    func setTextFieldAttributes() {
    
        topTextField.borderStyle = UITextBorderStyle.None
        bottomTextField.borderStyle = UITextBorderStyle.None
        
        topTextField.backgroundColor = UIColor.clearColor()
        bottomTextField.backgroundColor = UIColor.clearColor()
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        setTextFieldAttributes()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        
        if imagePickerView.image == nil {
            shareButton.enabled = false
            instructionLabel.hidden = false
        } else {
            shareButton.enabled = true
            instructionLabel.hidden = true
        }
        
        cameraButton?.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Button methods - Image or Camera or Share
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromAlbum (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func shareButton(sender: AnyObject) {
        //Generate the Memed Image and store it in the memedImage variable
        memedImage = generateMemedImage()
        
        if memedImage != nil {
            let image = memedImage
            let controller = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
            controller.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error:NSError?) in
                
                if !completed {
                    print("Sharing cancelled by user")
                } else {
                    self.save()
                
                    switch activityType! {
                    case UIActivityTypePostToFacebook:
                        print("Facebook")
                    case UIActivityTypePostToTwitter:
                        print("Twitter")
                    case UIActivityTypeSaveToCameraRoll:
                        print("Saved to camera roll")
                    case UIActivityTypeMessage:
                        print("Sent as text message")
                    case UIActivityTypePostToFlickr:
                        print("Flickr")
                    case UIActivityTypePostToVimeo:
                        print("Vimeo")
                    case UIActivityTypeMail:
                        print("Shared via email")
                    default:
                        print("default called - some other selection was made")
                    }
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    
    //MARK: Save method and generate method for meme
    func save() {
        //Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, imageOriginal: imagePickerView.image!, imageMeme: memedImage!)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
    }
    
    func generateMemedImage() -> UIImage {
        //Hide toolbar and navbar
        toolbar.hidden = true
        instructionLabel.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        toolbar.hidden = false
        
        return memedImage
    }
    
    
    //MARK: Text Field methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    
    //MARK: Keyboard methods
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = getKeyboardHeight(notification) * -1
        } else {
            self.view.frame.origin.y = 0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    
}

