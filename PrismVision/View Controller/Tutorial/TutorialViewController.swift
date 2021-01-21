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
        pageControl.isEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
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
    }
    private func addActions() {
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonClicked), for: .touchUpInside)
    }
    @objc private func nextButtonClicked() {
        if nextButton.currentTitle != "Next" {
            dismiss(animated: true, completion: nil)
        }
        else {
            manageContols(.next)
        }
        
    }
    @objc private func previousButtonClicked() {
        manageContols(.previous)
    }

    private func configurCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemGray
        collectionView.register(TutorialCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
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
            nextButton.setTitle("Next", for: .normal)
        }
        if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1 {
            nextButton.setTitle("Done", for: .normal)
        }
    }
}


//MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension TutorialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItemsInSection = 8
        
        pageControl.numberOfPages = numberOfItemsInSection
        return numberOfItemsInSection
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TutorialCollectionViewCell
        cell.backgroundColor = .systemGray
        var titleString: String
        var bodyString: String
        switch indexPath.item {
        case 0:
            // Flash Cell
            cell.imageView.image = #imageLiteral(resourceName: "Flash")
            titleString = NSLocalizedString(TutorialStrings.Flash.title.stringValue, comment: TutorialStrings.Flash.title.stringValue)
            bodyString = NSLocalizedString(TutorialStrings.Flash.body.stringValue, comment: TutorialStrings.Flash.body.stringValue)
            cell.descriptionLabel.attributedText = setCellsTextView(title: titleString, body: bodyString)
        case 1:
            // Camera Cell
            cell.imageView.image = #imageLiteral(resourceName: "Camera")
            titleString = NSLocalizedString(TutorialStrings.Camera.title.stringValue, comment: TutorialStrings.Camera.title.stringValue)
            bodyString = "1. Allows you to detect colors \n2. Make sure to have the \"Silent Mode\" turned off if you want to lessen to when the app has captured the color"
            cell.descriptionLabel.attributedText = setCellsTextView(title: titleString, body: bodyString)
        case 2:
            // Color Cell
            cell.imageView.image = #imageLiteral(resourceName: "Color")
            titleString = "Color Label"
            bodyString = "Shows the detected color"
            cell.descriptionLabel.attributedText = setCellsTextView(title: titleString, body: bodyString)
        case 3:
            // Hex Cell
            cell.imageView.image = #imageLiteral(resourceName: "Hex")
            titleString = "Hex Label"
            bodyString = "Shows the Hex value of the detected color"
            cell.descriptionLabel.attributedText = setCellsTextView(title: titleString, body: bodyString)
        case 4:
            // Album Cell
            cell.imageView.image = #imageLiteral(resourceName: "Album")
            titleString = "Album Button"
            bodyString = "1. Access the photos' album on your phone \n2. Detect colors on the chosen images."
            cell.descriptionLabel.attributedText = setCellsTextView(title: titleString, body: bodyString)
        case 5:
            // Pointer Cell
            cell.imageView.loadGif(name: "Pointer Movement")
            titleString = "The Pointer"
            bodyString = "Drag it around the screen to detect the colors of different points on the screen"
            cell.descriptionLabel.attributedText = setCellsTextView(title: titleString, body: bodyString)
        case 6:
            // Settings Cell
            cell.imageView.image = #imageLiteral(resourceName: "Settings t")
            titleString = "Settings Button"
            bodyString = "1. Change the language of the app \n2. Revisit this tutorial"
            cell.descriptionLabel.attributedText = setCellsTextView(title: titleString, body: bodyString)
        case 7:
            // Enjoy Cell
            cell.imageView.image = nil
            cell.descriptionLabel.textAlignment = .center
            titleString = "Enjoy! ✨"
            cell.descriptionLabel.text = titleString
            cell.descriptionLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        default:
            break
        }
    
        return cell
    }
    func setCellsTextView(title: String, body: String) -> NSMutableAttributedString{
        let titleString = NSAttributedString(string: title,
                                             attributes: [
                                                .font: UIFont.boldSystemFont(ofSize: 18),
                                                .foregroundColor : UIColor.black])
        let bodyString = NSAttributedString(string: "\n\n\(body)",
                                            attributes: [
                                                .font: UIFont.systemFont(ofSize: 18),
                                                .foregroundColor : UIColor.black])
        let description = NSMutableAttributedString(string: "")
        description.append(titleString)
        description.append(bodyString)
        return description
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
