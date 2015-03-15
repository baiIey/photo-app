//
//  LibraryViewController.swift
//  photo app
//
//  Created by Patrick Wong on 3/14/15.
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "photocellID"

class LibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PHPhotoLibraryChangeObserver {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var images: PHFetchResult! = nil
    var imageManager = PHCachingImageManager()
//    var imageCacheController: ImageCacheController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
//        imageCacheController = ImageCacheController(imageManager: imageManager, images: images, preheatSize: 1)
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self) // Registering for update notifications
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self

        self.photoCollectionView.reloadData()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotoCollectionViewCell
        cell.imageManager = imageManager
        cell.imageAsset = images?.objectAtIndex(indexPath.item) as? PHAsset
        
        // configure cell
        
        return cell
    }
    
    // PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(changeInstance: PHChange!) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.images = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
            self.photoCollectionView.reloadData()
        })
    }
    
    // tap on photo to segue photo detail view
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        println("thumbnail tapped, transitioning")
        performSegueWithIdentifier("collectionSegue", sender: self)
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "collectionSegue"){
//            let controller:EditPhotoViewController = segue.destinationViewController as EditPhotoViewController
//            let indexPath: NSIndexPath = self.collectionView.indexPathForCell(sender as UICollectionViewCell)!
//            controller.index = indexPath.item
//            controller.images = self.images
//            controller.assetCollection = self.assetCollection
//            }
//    }
}
