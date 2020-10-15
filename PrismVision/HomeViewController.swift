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

class HomeViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pointer: UIImageView!
    
    var session: AVCaptureSession?;
    var input: AVCaptureDeviceInput?;
    var output: AVCapturePhotoOutput?;
    var previewLayer: AVCaptureVideoPreviewLayer?;
    var photoOutput = AVCapturePhotoOutput();
    
    @IBOutlet weak var cameraButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCameraView();
        cameraButton.layer.zPosition = 1;
        pointer.layer.zPosition = 1;
        label.layer.zPosition = 1;
        
    }

    @IBAction func cameraButtonClicked(_ sender: Any) {
        print("Yes");
        
        let photoSettings = AVCapturePhotoSettings();
//        photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatType.first {
//        photoSettings.previewPhotoFormat
        photoOutput.capturePhoto(with: photoSettings, delegate: self);
//        if let photoPreviewType = photoSettings.supportedRawPhotoPixelFormatTypes(for fileType: AVFileType).first {
//            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
//            photoOutput.capturePhoto(with: photoSettings, delegate: self);
//
//        }
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
      // 1
      let translation = gesture.translation(in: view)

      // 2
      guard let gestureView = gesture.view else {
        return
      }

      gestureView.center = CGPoint(
        x: gestureView.center.x + translation.x,
        y: gestureView.center.y + translation.y
      )
        
        print("Height, \(gestureView.bounds.height). Width, \(gestureView.bounds.width)");
        print(gestureView.center);
      // 3
      gesture.setTranslation(.zero, in: view)
    }
    
}
// MARK: - CoreML
extension HomeViewController {

    func setUp() -> VNCoreMLRequest {
        let model = try! VNCoreMLModel(for: PrisimVision3().model)

        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
            self?.processClassifications(for: request, error: error)
        })
//        request.imageCropAndScaleOption = .centerCrop
        return request
    }
    func runVisionRequest(ciImage: CIImage, classificationRequest: VNCoreMLRequest) {
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            var classificationLabel = "";
            guard let results = request.results else {
                classificationLabel = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation];
            let value = classifications.first?.identifier;
            let confidence = ((classifications.first?.confidence)! as Float) * 100;
            self.label.text = "Color: \(value!), Confidence: \(confidence) "
            print(value!, confidence);
        }
        
    }
}

// MARK:- AVFoundation
extension HomeViewController {

    private func setupCameraView() {
        session = AVCaptureSession()
        output = AVCapturePhotoOutput()
        
        let camera = getDevice(.back);
        
        //        avresourcea
        guard camera != nil else {
            /* Maybe Handel the error with a message. */
            print("Camera is not available!!!");
            return;
//            fatalError()
        }
        add(device: camera!, to: input);
        
        
//        addInputAndOutputToSession();
        
        addVideo();
        
        configurPreviewLayer();
        
        cameraView.layer.addSublayer(previewLayer!)
        
        session?.startRunning()
    }
    
    private func getDevice(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if position == .back {
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position);
            return device
        } else { return nil }
    }
    private func add(device: AVCaptureDevice, to input: AVCaptureDeviceInput?) {
        
        do {
            self.input = try AVCaptureDeviceInput(device: device);
        } catch {
            self.input = nil
            print(error);
        }
    }
    private func addInputAndOutputToSession() {
        guard input != nil, output != nil else {
            /* Maybe Handel the error with a message. */
            fatalError();
            
        }
        if session?.canAddInput(input!) == true {
            session?.addInput(input!);
        }
        if(session?.canAddOutput(output!) == true){
            session?.addOutput(output!)
        }
    }
    private func addVideo() {
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if ((session?.canAddInput(input)) == true) {
                    session?.addInput(input)
                }
            } catch let error {
                print("Failed to set input device with error: \(error)")
            }
            
            if ((session?.canAddOutput(photoOutput)) == true) {
                session?.addOutput(photoOutput)
            }
        }
        
    }
    private func configurPreviewLayer() {
//        photoOutput = AVCapturePhotoOutput();
        previewLayer = AVCaptureVideoPreviewLayer(session: session!);
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
        previewLayer?.frame = cameraView.bounds
    }
    
    
//    private func handleTakePhoto() {
//        let photoSettings = AVCapturePhotoSettings()
//        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
//            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
//            photoOutput.capturePhoto(with: photoSettings, delegate: self)
//        }
//    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
        
        let request = setUp();
//        let cImage = CIImage(image: previewImage!)!;
//        runVisionRequest(ciImage: cImage, classificationRequest: request);
//        let vc = storyboard?.instantiateViewController(identifier: "Preview") as! PhotoPreviewView;
//        vc.image = previewImage;
//
//        present(vc, animated: true, completion: nil);
        
//        let photoPreviewContainer = PhotoPreviewView(frame: self.view.frame)
//        photoPreviewContainer.photoImageView.image = previewImage
        
        print(view.bounds.width, view.bounds.height);
        let resizedImage = resizeImage(image: previewImage!, targetSize: CGSize(width: view.bounds.width, height: view.bounds.height));
        
        print(previewImage?.size.width, previewImage?.size.height);
        print("Screen Size:", view.bounds.width, view.bounds.height)
        print("ResisedImage:", resizedImage.size.width, resizedImage.size.height)
//        let rect2 = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//        let croppedImage = previewImage?.crop(rect: <#T##CGRect#>)
        let pointerYLocation = pointer.center.y;
        let imageHeight = resizedImage.size.height;
        let screenHeight = view.bounds.height;
        let correction2 = pointerYLocation * imageHeight / screenHeight;
        let constant = view.bounds.height / 2;
        let correction = constant - resizedImage.size.height/2;
        let rect = CGRect(x: pointer.center.x, y: correction2, width: pointer.bounds.width, height: pointer.bounds.height);
        
//        let anotherResise = resizeImage(image: resizedImage, targetSize: CGSize()
        let newImage = resizedImage.crop(rect: rect);
        
        let cImage = CIImage(image: resizedImage)!;
        runVisionRequest(ciImage: cImage, classificationRequest: request);
        
                let vc = storyboard?.instantiateViewController(identifier: "Preview") as! PhotoPreviewView;
                vc.image = newImage;

                present(vc, animated: true, completion: nil);
        
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    
}

