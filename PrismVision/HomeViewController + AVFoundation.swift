//
//  HomeViewController + AVFoundation.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 19/10/2020.
//

import AVFoundation;
import UIKit;


// MARK:- AVFoundation
extension HomeViewController {
    
    func setupCameraView() {
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
        let extetionResizedImage = previewImage!.resizeImage(targetSize: CGSize(width: view.bounds.height, height: view.bounds.height));
        print("ExtesnionResisedImage:", extetionResizedImage.size.width, extetionResizedImage.size.height);
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
        
        let cImage = CIImage(image: newImage)!;
        //        runVisionRequest(ciImage: cImage, classificationRequest: request);
        runVisionRequest2(ciImage: cImage, classificationRequest: request) {
            guard let location = self.tempPointerLocation else { return }
            DispatchQueue.main.async {
                //TODO: Make a constraint and add it to the pointer in its new location and delete the old one!!!
                
                //                self.pointer.frame.origin = location;
                print("pointerLocation3", self.tempPointerLocation);
            }
            
        }
        
//                        let vc = storyboard?.instantiateViewController(identifier: "Preview") as! PhotoPreviewView;
//                        vc.image = newImage;
//
//                        present(vc, animated: true, completion: nil);
        
    }
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    // MARK:- Helper(s)
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings();
        photoOutput.capturePhoto(with: photoSettings, delegate: self);
    }
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
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
