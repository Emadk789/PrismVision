//
//  TutorialCollectionViewCell.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 21/01/2021.
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var descriptionLabel: UITextView = {
        let textView = UITextView()
        
        textView.text = "Test Label"
        textView.textColor = .black
        textView.backgroundColor = .systemGray
        textView.allowsEditingTextAttributes = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubViews()
        configurAnchors()
    }
    private func addSubViews() {
        addSubview(imageView)
        addSubview(descriptionLabel)
        
    }
    private func configurAnchors() {
        configurImageViewAnchors()
        configurDescriptionLabelAnchors()
    }
    
    private func configurImageViewAnchors() {
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
    }
    private func configurDescriptionLabelAnchors() {
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
