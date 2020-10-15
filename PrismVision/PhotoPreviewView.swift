//
//  PhotoPreviewView.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 14/10/2020.
//

import UIKit
import Photos

class PhotoPreviewView: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        imageView.image = image;
    }
    
    
}
