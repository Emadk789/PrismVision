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
    @IBOutlet weak var colorPrivewImageView: UIImageView!
    @IBOutlet weak var forTestingActualColor: UILabel!
    @IBOutlet weak var forTesting: UILabel!
    @IBOutlet weak var forTestingStack: UIStackView!
    @IBOutlet weak var cameraUIimage: UIImageView!
    @IBOutlet weak var hexLabel: UILabel!
//    @IBOutlet weak var stackViewLabels: UIStackView!
    @IBOutlet weak var seperatorLabel: UILabel!
    
    var session: AVCaptureSession?;
    var input: AVCaptureDeviceInput?;
    var output: AVCapturePhotoOutput?;
    var previewLayer: AVCaptureVideoPreviewLayer?;
    var photoOutput = AVCapturePhotoOutput();
    var tempPointerLocation: CGPoint!;
    
    var testImage: UIImage?
    

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
        pickerView.delegate = self;
        
        setupCameraView();
        setupZPositions();
        
        label.isHidden = true;
        hexLabel.isHidden = true
        seperatorLabel.isHidden = true
        setUpPointer(pointer);
        
        setAccessibillityLabels();
        
        colorPrivewImageView.layer.cornerRadius = colorPrivewImageView.frame.size.width/2
        
        


    }
    private func setupZPositions() {
        cameraButton.layer.zPosition = 1;
        pointer.layer.zPosition = 1;
        label.layer.zPosition = 1;
        flashButton.layer.zPosition = 1;
        albumButton.layer.zPosition = 1;
        settingsButton.layer.zPosition = 1;
        colorPrivewImageView.layer.zPosition = 1
        
        forTestingActualColor.layer.zPosition = 1
        forTestingStack.layer.zPosition = 1
        seperatorLabel.layer.zPosition = 1
        hexLabel.layer.zPosition = 1
    }
    private func setAccessibillityLabels() {
        cameraButton.accessibilityLabel = NSLocalizedString("Camera", comment: "The camera Button");

        flashButton.accessibilityLabel = NSLocalizedString("Flash", comment: "The flash Button");
        albumButton.accessibilityLabel = NSLocalizedString("Album", comment: "The Album Button");
        settingsButton.accessibilityLabel = NSLocalizedString("Settings", comment: "The Settings Button");
        pointer.accessibilityLabel = NSLocalizedString("Pointer", comment: "The Pointer Image");
        
        hexLabel.isAccessibilityElement = false
        
    }

    override func setupPointerConstraints(_ pointer: UIImageView) {
        pointer.translatesAutoresizingMaskIntoConstraints = false;
        pointerHorizantalConstranit = pointer.centerXAnchor.constraint(equalTo: view.centerXAnchor);
        pointerHorizantalConstranit?.isActive = true;
        pointerVerticalConstranit = pointer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        pointerVerticalConstranit?.isActive = true;
        
    }

    @IBAction func cameraButtonClicked(_ sender: Any) {
//        let resizedImage2 = cameraView.makeSnapshot()!;
//        testImage2 = resizedImage2
////        testImage = imageUnderPointer(image: resizedImage2, pointer: pointer);
//        updateLabel()
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
        pickerView.allowsEditing = true
        present(pickerView, animated: true, completion: nil);
        
    }
    override func handlePointerPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

          guard let gestureView = pointer else {
          return
        }
        if sender.state == .changed {
            pointerHorizantalConstranit?.constant += translation.x
            pointerVerticalConstranit?.constant += translation.y
        }
//        if sender.state == .ended {
//
////              addNewConstraints(to: gestureView);
//
////              capturePhoto();
//          }
        
//          gestureView.center = CGPoint(
//              x: gestureView.center.x + translation.x,
//              y: gestureView.center.y + translation.y
//          )
          
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
    
    override func updateLabel() {
        // call super.updateLabel() to run super implementation
        super.updateLabel()
        
        
        
//        let vc = storyboard?.instantiateViewController(identifier: "Preview") as! PhotoPreviewView
//        
//        
//        let button2 = UIButton()
//        button2.frame = CGRect(x: pointer.frame.minX, y: pointer.frame.minY, width: 30, height: 30)
//            button2.clipsToBounds = true
//            button2.setTitle("Tesing Button", for: .normal)
//        cameraUIimage.addSubview(button2)
//        vc.image = testImage2

        
        self.label.text = localizedLabelText
        self.label.isHidden = false
        
        self.hexLabel.text = "\(paletteHexStringCode)"
        self.hexLabel.isHidden =  false
        
        self.seperatorLabel.isHidden = false
        
        colorPrivewImageView.backgroundColor = closestPaletteColorHTMLCode
        forTesting.isHidden = false
        forTestingActualColor.isHidden = false
        forTestingActualColor.text = "Actual Detected Color: \(imaggaParentColor2)"
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil);
//        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage;
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let vc = storyboard?.instantiateViewController(identifier: "ImagePreview") as! ImagePickerPhotoPreviewController;

        vc.image = image;
        present(vc, animated: true);
    }
}
