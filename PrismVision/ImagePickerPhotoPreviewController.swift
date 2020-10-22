//
//  ImagePickerPhotoPreviewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 22/10/2020.
//

import UIKit;

class ImagePickerPhotoPreviewController: PhotoPreviewView {
    
//    @IBOutlet weak var pointer: UIImageView!
    @IBOutlet weak var pointer: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setUpPointer(pointer);
    }
//    func setUpPointer(sender: UIViewController, _ pointer: UIImageView) {
    
//        setupPointerConstraints(pointer);
////        addPanTarget(sender: sender);
//
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
//        pointer.target(forAction: #selector(pointerClicked(_:)), withSender: self);
//        setUpPointer(sender: self, pointer);
        
    }
    override func handlePointerPan(_ sender: UIPanGestureRecognizer) {
        
    }
    
    
    
}
