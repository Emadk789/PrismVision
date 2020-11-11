//
//  HomeViewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 14/10/2020.
//

import UIKit
import AVFoundation;
import Vision;
import CoreML;

class HomeViewController: HomeAndImagePickerSuperViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pointer: UIImageView!
    @IBOutlet weak var flashButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var session: AVCaptureSession?;
    var input: AVCaptureDeviceInput?;
    var output: AVCapturePhotoOutput?;
    var previewLayer: AVCaptureVideoPreviewLayer?;
    var photoOutput = AVCapturePhotoOutput();
    var tempPointerLocation: CGPoint!;
    
//    var request: VNCoreMLRequest!;
    
    var pointerHorizantalConstranit: NSLayoutConstraint?;
    var pointerVerticalConstranit: NSLayoutConstraint?;
    var pointerNewTopConstranit: NSLayoutConstraint?;
    var pointerNewleftConstranit: NSLayoutConstraint?;
    
    let pickerView: UIImagePickerController = {
        let pikerView = UIImagePickerController();
        pikerView.sourceType = .photoLibrary;
        return pikerView;
    }()
    
    //TODO: Implemnt the transelation.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self;
        
        setupCameraView();
        setupZPositions();
        
        label.isHidden = true;
        setUpPointer(pointer);
        
        setAccessibillityLabels();
//        accessibilityElements = [
//            flashButton,
//            settingsButton,
//         
//            albumButton,
////         pointer,
//            cameraButton,
//            label
//         ].compactMap { $0 }

    }
    private func setupZPositions() {
        cameraButton.layer.zPosition = 1;
        pointer.layer.zPosition = 1;
        label.layer.zPosition = 1;
        flashButton.layer.zPosition = 1;
        albumButton.layer.zPosition = 1;
        settingsButton.layer.zPosition = 1;
        
        
    }
    private func setAccessibillityLabels() {
        cameraButton.accessibilityLabel = NSLocalizedString("Camera", comment: "The camera Button");
        flashButton.accessibilityLabel = NSLocalizedString("Flash", comment: "The flash Button");
        albumButton.accessibilityLabel = NSLocalizedString("Album", comment: "The Album Button");
        settingsButton.accessibilityLabel = NSLocalizedString("Settings", comment: "The Settings Button");
        pointer.accessibilityLabel = NSLocalizedString("Pointer", comment: "The Pointer Image");
        
    }

    override func setupPointerConstraints(_ pointer: UIImageView) {
            pointer.translatesAutoresizingMaskIntoConstraints = false;
        pointerHorizantalConstranit = pointer.centerXAnchor.constraint(equalTo: view.centerXAnchor);
        pointerHorizantalConstranit?.isActive = true;
        pointerVerticalConstranit = pointer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        pointerVerticalConstranit?.isActive = true;
        
    }

    @IBAction func cameraButtonClicked(_ sender: Any) {
        capturePhoto();
    }
    @IBAction func flashButtonClicked(_ sender: Any) {
        toggleFlash();
    }
    @IBAction func settingsButtonClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController;
        
        present(vc, animated: true);
    }
    @IBAction func albumButtonClicked(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true else { return }
        
        present(pickerView, animated: true, completion: nil);
        
//        let x =
//        print("Yes");
//        let albumViewController = AlbumViewController();
//        present(albumViewController, animated: true, completion: nil);
//        show(AlbumViewController, sender: nil);
        
    }
    override func handlePointerPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

          guard let gestureView = pointer else {
          return
        }
        if sender.state == .ended {
              
              addNewConstraints(to: gestureView);
              
              capturePhoto();
          }
        
          gestureView.center = CGPoint(
              x: gestureView.center.x + translation.x,
              y: gestureView.center.y + translation.y
          )
          
        sender.setTranslation(.zero, in: view)
    }
    
    //MARK:- Helper(s)
    private func addNewConstraints(to gestureView: UIView) {
        pointerHorizantalConstranit?.isActive = false;
        pointerVerticalConstranit?.isActive = false;
        if (pointerNewTopConstranit?.isActive) != nil ||  (pointerNewleftConstranit?.isActive) != nil {
            pointerNewTopConstranit?.isActive = false;
            pointerNewleftConstranit?.isActive = false;
        }
        pointerNewTopConstranit = self.pointer.topAnchor.constraint(equalTo: self.cameraView.topAnchor, constant: gestureView.center.y);
        pointerNewTopConstranit?.isActive = true;
        pointerNewleftConstranit = self.pointer.leftAnchor.constraint(equalTo: self.cameraView.leftAnchor, constant: gestureView.center.x);
        pointerNewleftConstranit?.isActive = true;
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil);
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage;
        let vc = storyboard?.instantiateViewController(identifier: "ImagePreview") as! ImagePickerPhotoPreviewController;
        vc.image = image;
//        vc.modalPresentationStyle = .fullScreen;
        present(vc, animated: true);
    }
}



    
    
    


