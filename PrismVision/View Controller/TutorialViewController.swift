//
//  TutorialViewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 18/01/2021.
//

import UIKit

class TutorialViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            return layout
        }()
        
        let collectionView = UICollectionView(frame: .null, collectionViewLayout: collectionViewLayout)
        collectionView.allowsSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.tintColor = .black
        button.contentEdgeInsets.left = 8
        button.contentEdgeInsets.right = 8
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray2.cgColor
        
        button.backgroundColor = .secondaryLabel
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Previous", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.tintColor = .black
        
        button.contentEdgeInsets.left = 8
        button.contentEdgeInsets.right = 8
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray2.cgColor
        
        button.backgroundColor = .secondaryLabel
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.numberOfPages = 7
        pageControl.tintColor = .systemRed
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        addSubViews()
        configurCollectionView()
        configurViewsAnchors()
    }
    private func addSubViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(previousButton)
    }

    private func configurCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemGray
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    private func configurViewsAnchors() {
        configurCollectionViewAnchors()
        configurNextButtonAnchors()
        configurPreviousButtonAnchors()
        configurPageControlAnchors()
    }
    private func configurCollectionViewAnchors() {
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
    }
    private func configurNextButtonAnchors() {
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    private func configurPreviousButtonAnchors() {
        previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        previousButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    private func configurPageControlAnchors() {
        pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
}

class TutorialCollectionViewCell: UICollectionViewCell {
}

extension TutorialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = 3
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .systemGray3
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            if let indexPath = collectionView.indexPath(for: cell) {
                pageControl.currentPage = indexPath.item
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize
        let screenWidth = collectionView.frame.width
        let screenHeight = collectionView.frame.height
        
        size = CGSize(width: screenWidth, height: screenHeight)
        
        return size
    }
    
    
}
