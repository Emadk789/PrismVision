//
//  HomeViewController + AVFoundation.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 19/10/2020.
//

import AVFoundation;
import UIKit;
import Alamofire


// MARK:- AVFoundation
extension HomeViewController {
    
    func setupCameraView() {
        session = AVCaptureSession()
        output = AVCapturePhotoOutput()
        
        let camera = getDevice(.back);

        guard camera != nil else {
            /* Maybe Handel the error with a message. */
            print("Camera is not available!!!");
            return;

        }
        add(device: camera!, to: input);
        
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
        previewLayer = AVCaptureVideoPreviewLayer(session: session!);
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
        previewLayer?.frame = cameraView.bounds
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)

        let resizedImage = resizeImage(image: previewImage!, targetSize: CGSize(width: view.bounds.width, height: view.bounds.height));

        
        testImage = imageUnderPointer(image: resizedImage, pointer: pointer);
        
        getColors(image: resizedImage)

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
