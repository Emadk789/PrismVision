//
//  HomeAndImagePickerSuperViewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 23/10/2020.
//

import UIKit
import Vision;
import CoreML

class HomeAndImagePickerSuperViewController: UIViewController {
    var coreMLLabel: String = "";
    var request: VNCoreMLRequest!;
    override func viewDidLoad() {
        super.viewDidLoad()

        request = setUp();
        // Do any additional setup after loading the view.
    }
    
    func setUp() -> VNCoreMLRequest {
        let prisimVison = try! PrisimVision3(configuration: .init());
        let model = try! VNCoreMLModel(for: PrisimVision3().model)
//        let model = try! VNCoreMLModel(for: prisimVison.model)

        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
            self?.processClassifications(for: request, error: error)
            
        })
        return request
    }
//    func runVisionRequest(ciImage: CIImage, classificationRequest: VNCoreMLRequest) {
//        DispatchQueue.global(qos: .userInitiated).async {
//            let handler = VNImageRequestHandler(ciImage: ciImage)
//            do {
//                try handler.perform([classificationRequest])
//
//            } catch {
//
//                print("Failed to perform classification.\n\(error.localizedDescription)")
//            }
//        }
//    }
    func processClassifications(for request: VNRequest, error: Error?) {
//
            var classificationLabel = "";
            guard let results = request.results else {
                classificationLabel = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation];
            let value = classifications.first?.identifier;
        var confidence = ((classifications.first?.confidence)! as Float) * 100;
        confidence.round(.toNearestOrAwayFromZero)
//        print("pointerLocation", pointer.center);
        DispatchQueue.main.async {
            self.coreMLLabel = "Color: \(value!), Confidence: \(confidence) ";
            print("In Processclassification", value!, confidence);
        }
//        correctPointerLocation();
    }
//    func correctPointerLocation() {
//        DispatchQueue.main.async {
//            print("pointerLocation2", self.pointer.center);
//        }
//    }
    func runVisionRequest2(ciImage: CIImage, classificationRequest: VNCoreMLRequest, completionHandler: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([classificationRequest])
                completionHandler();
//                DispatchQueue.main.async {
//                    guard let location = self.tempPointerLocation else { return }
//                    self.pointer.center = location;
//                    print("pointerLocation3", self.tempPointerLocation);
//                }
                
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
//    func processClassifications2(for request: VNRequest, error: Error?, completionHandler: @escaping () -> Void) {
//    //
//            var classificationLabel = "";
//            guard let results = request.results else {
//                classificationLabel = "Unable to classify image.\n\(error!.localizedDescription)"
//                return
//            }
//            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
//            let classifications = results as! [VNClassificationObservation];
//            let value = classifications.first?.identifier;
//        let confidence = ((classifications.first?.confidence)! as Float) * 100;
//    //        print("pointerLocation", pointer.center);
//        DispatchQueue.main.async {
//            self.coreMLLabel = "Color: \(value!), Confidence: \(confidence) ";
//            print(value!, confidence);
//            completionHandler();
//        }
//    //        correctPointerLocation();
//    }
    //    func correctPointerLocation() {
    //        DispatchQueue.main.async {
    //            print("pointerLocation2", self.pointer.center);
    //        }
    //
    
    func imageUnderPointer(image resizedImage: UIImage, pointer: UIImageView) -> UIImage? {
        let imageHeight = resizedImage.size.height;
        let screenHeight = view.bounds.height;
        let correction2 = pointer.center.y * imageHeight / screenHeight;
//        let constant = view.bounds.height / 2;
//        let correction = constant - resizedImage.size.height/2;
        let rect = CGRect(x: pointer.center.x, y: correction2, width: pointer.bounds.width, height: pointer.bounds.height);
        
        //        let anotherResise = resizeImage(image: resizedImage, targetSize: CGSize()
        let newImage = resizedImage.crop(rect: rect);
        return newImage;
    }
    

}
