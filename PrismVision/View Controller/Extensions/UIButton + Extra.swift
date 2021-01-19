//
//  UIButton + Extra.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 18/01/2021.
//

import UIKit


extension UIButton {
    convenience init(title: String?) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        setTitleColor(.black, for: .normal)
        
        contentEdgeInsets.left = 8
        contentEdgeInsets.right = 8
        layer.masksToBounds = true
        layer.cornerRadius = 8
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray2.cgColor
        
        backgroundColor = .secondaryLabel
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
