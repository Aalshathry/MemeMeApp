//
//  SentMemesViewController.swift
//  MemeMe V1.0
//
//  Created by Abdulrahman Al Shathry on 23/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import UIKit


class SentMemesCollectionViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create new Meme", style: .plain, target: self, action: #selector(SentMemesCollectionViewController.createNewMeme))
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @objc func createNewMeme() {

        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemes") as! ViewController
        self.present(nextViewController, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return appDelegate.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let current :Meme = appDelegate.memes[indexPath.row]
        cell.ImageProduct.image = current.memedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.appDelegate.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
