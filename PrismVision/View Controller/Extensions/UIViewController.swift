//
//  UIViewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 08/11/2020.
//

import UIKit;

extension UIViewController {
    func setUpPointer(_ pointer: UIImageView) {
        
        addPanTarget(pointer);
        setupPointerConstraints(pointer);
        
    }
    @objc func setupPointerConstraints(_ pointer: UIImageView) {
        let pointerHorizantalConstranit: NSLayoutConstraint?
        let pointerVerticalConstranit: NSLayoutConstraint?
            pointer.translatesAutoresizingMaskIntoConstraints = false;
        pointerHorizantalConstranit = pointer.centerXAnchor.constraint(equalTo: view.centerXAnchor);
        pointerHorizantalConstranit?.isActive = true;
        pointerVerticalConstranit = pointer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        pointerVerticalConstranit?.isActive = true;
        
    }
    func addPanTarget(_ pointer: UIImageView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePointerPan(_:)))
        pointer.addGestureRecognizer(pan);
    }
    @objc func handlePointerPan(_ sender: UIPanGestureRecognizer) {}
    
}
