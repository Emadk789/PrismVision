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
    
    private let nextButton = UIButton(title: "Next")
    private let previousButton = UIButton(title: "Previous")
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.numberOfPages = 7
        pageControl.tintColor = .systemRed
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Label"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        previousButton.isHidden = true
        addSubViews()
        addActions()
        configurCollectionView()
        configurViewsAnchors()
    }
    private func addSubViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(previousButton)
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
    }
    private func addActions() {
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonClicked), for: .touchUpInside)
    }
    @objc private func nextButtonClicked() {
        manageContols(.next)
    }
    @objc private func previousButtonClicked() {
        manageContols(.previous)
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
        configurImageViewAnchors()
        configurDescriptionLabelAnchors()
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
    private func configurImageViewAnchors() {
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
    }
    private func configurDescriptionLabelAnchors() {
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
    }
    // MARK:- Helper(s)

    enum Controls {
        case next, previous
    }
    private func manageContols(_ control: Controls) {
        let indexPaths = collectionView.indexPathsForVisibleItems
        let indexPath = indexPaths[0]
        var newIndexPath: IndexPath
        
        switch control {
        case .next:
            newIndexPath = IndexPath(item: indexPath.item + 1, section: 0)
        case .previous:
            newIndexPath = IndexPath(item: indexPath.item - 1, section: 0)
        }
        collectionView.scrollToItem(at: newIndexPath, at: .bottom, animated: true)
        updateContolsVisibility(for: newIndexPath)
    }
    private func updateContolsVisibility(for indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
        if indexPath.item == 0 {
            previousButton.isHidden = true
        }
        if indexPath.item != 0 {
            previousButton.isHidden = false
            nextButton.isHidden = false
        }
        if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1 {
            nextButton.isHidden = true
            //TODO: Show Done Button! or Change the title of the next button
        }
    }
}

class TutorialCollectionViewCell: UICollectionViewCell {
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension TutorialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = 3
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .systemGray3
        if indexPath.item == 0 {
            cell.backgroundColor = .systemBlue
        }
        if indexPath.item == 1 {
            cell.backgroundColor = .systemPurple
        }
        if indexPath.item == 2 {
            cell.backgroundColor = .systemPink
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            if let indexPath = collectionView.indexPath(for: cell) {
                updateContolsVisibility(for: indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize
        let screenWidth = collectionView.frame.width
        let screenHeight = collectionView.frame.height
        
        size = CGSize(width: screenWidth, height: screenHeight)
        
        return size
    }
    
    
}
