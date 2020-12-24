//
//  ImagePickerPhotoPreviewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 22/10/2020.
//

import UIKit;
import Vision;

class ImagePickerPhotoPreviewController: PhotoPreviewView {

    @IBOutlet weak var pointer: UIImageView!
    @IBOutlet weak var privewLabel: UILabel!
    
    var pointerHorizantalConstranit: NSLayoutConstraint?
    var pointerVerticalConstranit: NSLayoutConstraint?
    var pointerNewTopConstranit: NSLayoutConstraint?
    var pointerNewleftConstranit: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad();
        setUpPointer(pointer);
        privewLabel.isHidden = true;
        
        pointer.accessibilityLabel = NSLocalizedString("Pointer", comment: "The Pointer Image");
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
            var resizedImage = (image?.resizeImage(targetSize: CGSize(width: view.bounds.width, height: view.bounds.height)))!
            
            // TODO: Take a screenshout of the image and pass it to the model.

            resizedImage = view.makeSnapshot()!;

            let newImage = imageUnderPointer(image: resizedImage, pointer: pointer);
            
            getColors(image: newImage!)
        }
        
    }
    override func updateLabel() {
        // call super.updateLabel() to run super implementation
        super.updateLabel()
        
        self.privewLabel.text = localizedLabelText
        self.privewLabel.isHidden = false
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

extension UIView {
    func makeSnapshot() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: frame.size)
            return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
        } else {
            return layer.makeSnapshot()
        }
    }
}
extension CALayer {
    func makeSnapshot() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
}
