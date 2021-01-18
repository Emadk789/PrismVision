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
    @IBOutlet weak var colorPreviewLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var seperatorLabel: UILabel!
    var pointerHorizantalConstranit: NSLayoutConstraint?
    var pointerVerticalConstranit: NSLayoutConstraint?
    var pointerNewTopConstranit: NSLayoutConstraint?
    var pointerNewleftConstranit: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad();
        setUpPointer(pointer);
        colorPreviewLabel.isHidden = true;
        hexLabel.isHidden = true
        seperatorLabel.isHidden = true
        
        pointer.accessibilityLabel = NSLocalizedString("Pointer", comment: "The Pointer Image");
        hexLabel.isAccessibilityElement = false
        seperatorLabel.isAccessibilityElement = false
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
        
        if gesture.state == .changed {
            pointerHorizantalConstranit?.constant += transition.x
            pointerVerticalConstranit?.constant += transition.y
        }
        if gesture.state == .ended {
            
            endGestureHandelr()
            
        }
        gesture.setTranslation(.zero, in: view);
    }
    func endGestureHandelr() {
        var resizedImage = (image?.resizeImage(targetSize: CGSize(width: view.bounds.width, height: view.bounds.height)))!
        resizedImage = view.makeSnapshot()!;
        testImage2 = resizedImage
        let newImage = imageUnderPointer(image: resizedImage, pointer: pointer);
        testImage2 = newImage
        callGetColors(image: newImage!)
    }
    func callGetColors(image: UIImage) {
        getColors(image: image)
    }
    override func updateLabel() {
        // call super.updateLabel() to run super implementation
        super.updateLabel()
        
        self.colorPreviewLabel.text = localizedLabelText
        self.colorPreviewLabel.isHidden = false
        
        self.hexLabel.text = "\(paletteHexStringCode)"
        self.hexLabel.isHidden =  false
        
        self.seperatorLabel.isHidden = false
        
        self.colorPreviewLabel.text = localizedLabelText
        self.colorPreviewLabel.isHidden = false
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
