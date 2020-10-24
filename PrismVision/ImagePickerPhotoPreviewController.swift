//
//  ImagePickerPhotoPreviewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 22/10/2020.
//

import UIKit;
import Vision;

class ImagePickerPhotoPreviewController: PhotoPreviewView {
    
//    @IBOutlet weak var pointer: UIImageView!
    @IBOutlet weak var pointer: UIImageView!
    @IBOutlet weak var privewLabel: UILabel!
    
    var pointerHorizantalConstranit: NSLayoutConstraint?
    var pointerVerticalConstranit: NSLayoutConstraint?
    var pointerNewTopConstranit: NSLayoutConstraint?
    var pointerNewleftConstranit: NSLayoutConstraint?
//    var request2: VNCoreMLRequest!
    override func viewDidLoad() {
        super.viewDidLoad();
        setUpPointer(pointer);
//        request2 = setUp();
    }
//    func setUpPointer(sender: UIViewController, _ pointer: UIImageView) {
    
//        setupPointerConstraints(pointer);
////        addPanTarget(sender: sender);
//
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        print("This is the Image", image?.size.width ,image?.size.height);
        let newImage = image?.resizeImage(targetSize: CGSize(width: view.bounds.width, height: view.bounds.height))
        print("This is the Image", newImage?.size.width ,newImage?.size.height);
//        pointer.target(forAction: #selector(pointerClicked(_:)), withSender: self);
//        setUpPointer(sender: self, pointer);
        
    }
    
    override func setupPointerConstraints(_ pointer: UIImageView) {
            pointer.translatesAutoresizingMaskIntoConstraints = false;
        pointerHorizantalConstranit = pointer.centerXAnchor.constraint(equalTo: view.centerXAnchor);
        pointerHorizantalConstranit?.isActive = true;
        pointerVerticalConstranit = pointer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        pointerVerticalConstranit?.isActive = true;
        
    }
    override func handlePointerPan(_ gesture: UIPanGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        let transition = gesture.translation(in: view);
        
        gestureView.center = CGPoint(x: gestureView.center.x + transition.x, y: gestureView.center.y + transition.y);
        
        gesture.setTranslation(.zero, in: view);
        if gesture.state == .ended {
            updateConstraints(to: gestureView);
            let resizedImage = (image?.resizeImage(targetSize: CGSize(width: view.bounds.width, height: view.bounds.height)))!
            
            let newImage = imageUnderPointer(image: resizedImage, pointer: pointer);
            let vc = self.storyboard?.instantiateViewController(identifier: "Preview") as! PhotoPreviewView;
            vc.image = newImage;
            
            self.present(vc, animated: true, completion: nil);
            let ciImage = CIImage(image: newImage!);
            runVisionRequest2(ciImage: ciImage!, classificationRequest: request) {
                DispatchQueue.main.async {
                    self.privewLabel.text = self.coreMLLabel;
                    
                }
                
//                print("This is the CorMLLabel", self.coreMLLabel);
            }
        }
        
    }
    
    //MARK:- Helper(s)
    private func updateConstraints(to gestureView: UIView) {
        pointerHorizantalConstranit?.isActive = false;
        pointerVerticalConstranit?.isActive = false;
        if (pointerNewTopConstranit?.isActive) != nil ||  (pointerNewleftConstranit?.isActive) != nil {
            pointerNewTopConstranit?.isActive = false;
            pointerNewleftConstranit?.isActive = false;
        }
        pointerNewTopConstranit = self.pointer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: gestureView.center.y);
        pointerNewTopConstranit?.isActive = true;
        pointerNewleftConstranit = self.pointer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: gestureView.center.x);
        pointerNewleftConstranit?.isActive = true;
    }
    
    
    
    
    
    
    
}

