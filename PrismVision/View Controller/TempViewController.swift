//
//  TempViewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 20/01/2021.
//

import UIKit

class TempViewController: UIViewController {

    @IBOutlet weak var pointer: UIImageView!
    
    
    var pointerHorizantalConstranit: NSLayoutConstraint?;
    var pointerVerticalConstranit: NSLayoutConstraint?;
    var pointerNewTopConstranit: NSLayoutConstraint?;
    var pointerNewleftConstranit: NSLayoutConstraint?;
    
    let pickerView: UIImagePickerController = {
        let pikerView = UIImagePickerController();
        pikerView.sourceType = .photoLibrary;
        return pikerView;
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        // Do any additional setup after loading the view.
        setUpPointer(pointer)
    }
    override func setupPointerConstraints(_ pointer: UIImageView) {
//        let pointerHorizantalConstranit: NSLayoutConstraint?
//        let pointerVerticalConstranit: NSLayoutConstraint?
            pointer.translatesAutoresizingMaskIntoConstraints = false;
        pointerHorizantalConstranit = pointer.centerXAnchor.constraint(equalTo: view.centerXAnchor);
        pointerHorizantalConstranit?.isActive = true;
        pointerVerticalConstranit = pointer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        pointerVerticalConstranit?.isActive = true;
        
    }
    override func handlePointerPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

          guard let gestureView = pointer else {
          return
        }
//        if sender.state == .changed {
            pointerHorizantalConstranit?.constant += translation.x
            pointerVerticalConstranit?.constant += translation.y
        print(pointerHorizantalConstranit)
//        }
        sender.setTranslation(.zero, in: view)
    }
    
    
    @IBAction func AlbumButtonClicked(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true else { return }
        pickerView.allowsEditing = true
        present(pickerView, animated: true, completion: nil);
    }
    
}

extension TempViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil);

        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let vc = storyboard?.instantiateViewController(identifier: "ImagePreview") as! ImagePickerPhotoPreviewController;

        vc.image = image;
        present(vc, animated: true);
    }
}

