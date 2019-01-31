//
//  SentMemesTableViewController.swift
//  MemeMe V1.0
//
//  Created by Abdulrahman Al Shathry on 23/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import UIKit


class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create new Meme", style: .plain, target: self, action: #selector(SentMemesTableViewController.createNewMeme))
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @objc func createNewMeme() {
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemes") as! ViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.memes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let meme = self.appDelegate.memes[(indexPath as NSIndexPath).row]
        
        // Set the text and image
        cell.textLabel?.text = meme.topText + "   " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.appDelegate.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
