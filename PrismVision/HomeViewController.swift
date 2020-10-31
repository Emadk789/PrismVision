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
    
    //TODO: Add a logo to the witing screen and to the main application image.
    //TODO: search about how to transelate an application into Arabic!!
    //TODO: Implemnt the transelation.
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupcons
        //look into it!!!
        print(CGSize(width: view.bounds.width, height: view.bounds.height))
        pickerView.delegate = self;
        
        setupCameraView();
        setupZPositions();
        
        label.isHidden = true;
//        request = setUp();
        setUpPointer(pointer);
//        pointer2.backgroundColor = .systemRed;
//        cameraView.removeConstraint(pointerCenterY);
//        cameraView.removeConstraint(pointerCenterX);
//        print("PointerCosntrinats", cameraView.constraints)
        
        
        
        
    }
    private func setupZPositions() {
        cameraButton.layer.zPosition = 1;
        pointer.layer.zPosition = 1;
        label.layer.zPosition = 1;
        flashButton.layer.zPosition = 1;
        albumButton.layer.zPosition = 1;
        settingsButton.layer.zPosition = 1;
        
        
    }

    override func setupPointerConstraints(_ pointer: UIImageView) {
            pointer.translatesAutoresizingMaskIntoConstraints = false;
        pointerHorizantalConstranit = pointer.centerXAnchor.constraint(equalTo: view.centerXAnchor);
        pointerHorizantalConstranit?.isActive = true;
        pointerVerticalConstranit = pointer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        pointerVerticalConstranit?.isActive = true;
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
//        pointer.translatesAutoresizingMaskIntoConstraints = false;
//        self.pointerHorizantalConstranit = pointer.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor);
//        pointerHorizantalConstranit?.isActive = true;
//        pointerVerticalConstranit = pointer.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor)
//        pointerVerticalConstranit?.isActive = true;
    }

    @IBAction func cameraButtonClicked(_ sender: Any) {
        capturePhoto();
    }
    @IBAction func flashButtonClicked(_ sender: Any) {
        toggleFlash();
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

        // 2
          guard let gestureView = pointer else {
          return
        }
        if sender.state == .ended {
              
              addNewConstraints(to: gestureView);
              
              capturePhoto();
  //            tempPointerLocation = pointer.center;
          }

  //      gestureView.center = CGPoint(
  //        x: gestureView.center.x + translation.x,
  //        y: gestureView.center.y + translation.y
  //      )
          gestureView.center = CGPoint(
              x: gestureView.center.x + translation.x,
              y: gestureView.center.y + translation.y
          )
          
          print("handlePen","Height, \(gestureView.bounds.height). Width, \(gestureView.bounds.width)");
          print(gestureView.center);
          
        // 3
        sender.setTranslation(.zero, in: view)
    }
//    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
//      // 1
//      let translation = gesture.translation(in: view)
//
//      // 2
//        guard let gestureView = pointer else {
//        return
//      }
//        if gesture.state == .ended {
//
//            addNewConstraints(to: gestureView);
//
//            capturePhoto();
////            tempPointerLocation = pointer.center;
//        }
//
////      gestureView.center = CGPoint(
////        x: gestureView.center.x + translation.x,
////        y: gestureView.center.y + translation.y
////      )
//        gestureView.center = CGPoint(
//            x: gestureView.center.x + translation.x,
//            y: gestureView.center.y + translation.y
//        )
//
//        print("handlePen","Height, \(gestureView.bounds.height). Width, \(gestureView.bounds.width)");
//        print(gestureView.center);
//
//      // 3
//      gesture.setTranslation(.zero, in: view)
//
//
//
//    }
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
// TODO: Add the label to the ImagePickerPhotoPreviewController as well!!! Also, override the setupPointerConstraints
// TODO: Move the UIViewController to a file.
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



    
    
    


