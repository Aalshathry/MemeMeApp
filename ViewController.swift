//
//  ViewController.swift
//  MemeMe V1.0
//
//  Created by Abdulrahman Al Shathry on 02/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    
    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldsInit(topTextField, "TOP")
        textFieldsInit(bottomTextField, "BOTTOM")
        
        // below code to dismiss keyboard if touched anywhere in the application
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        shareButton.isEnabled = false
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel))
//
    }
    
//    @objc func cancel() {
//
////        let next = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemes") as! ViewController
////        self.present(next, animated: true, completion: nil)
//
//        //        let vc = UIStoryboard.init(name: "Create Meme", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
//        //        self.navigationController?.pushViewController(vc!, animated: true)
//        //
//        //        if let navigationController = self.navigationController {
//        let controller = self.navigationController!.viewControllers[1]
//        self.navigationController?.popToViewController(controller, animated: true)
//        //        }
//    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(sourceType: .camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        hideToolbar(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbar(false)

        return memedImage
    }
    
    func hideToolbar(_ bool: Bool){
        topToolbar.isHidden = bool
        bottomToolbar.isHidden = bool
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        let viewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: [])
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(viewController, animated: true, completion: nil)
        
        viewController.completionWithItemsHandler = {
            (activity, completed, item, error) in
            if(completed){
                self.save(meme)
            }
            self.cancel(self)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "Root") as! UITabBarController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    
    func save(_ meme: Meme){
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField{
            topTextField.text = ""
        } else{
            bottomTextField.text = ""
        }
    }
    
    func textFieldsInit(_ tf: UITextField,_  text: String){
        tf.textAlignment = .center
        tf.defaultTextAttributes = memeTextAttributes
        tf.text = text
        tf.delegate = self
    }
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        shareButton.isEnabled = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
}
