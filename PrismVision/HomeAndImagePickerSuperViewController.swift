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
    }
    
    func setUp() -> VNCoreMLRequest {
        //TODO: Make a green Black model!!!
        let prisimVison = try! PrisimVision3(configuration: .init());
        
        let model = try! VNCoreMLModel(for: PrisimVision3().model)
        
        let p = try! PrisimVision5(configuration: .init());
        let m = try! VNCoreMLModel(for: p.model);
        let model2 = try! VNCoreMLModel(for: PrisimVision5().model);

        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
            self?.processClassifications(for: request, error: error)
            
        })
        return request
    }
    func processClassifications(for request: VNRequest, error: Error?) {
            var classificationLabel = "";
            guard let results = request.results else {
                classificationLabel = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            let classifications = results as! [VNClassificationObservation];
            let value = classifications.first?.identifier;
        var confidence = ((classifications.first?.confidence)! as Float) * 100;
        confidence.round(.toNearestOrAwayFromZero)
        DispatchQueue.main.async {
            self.coreMLLabel = "Color: \(value!), Confidence: \(confidence) ";
            print("In Processclassification", value!, confidence);
        }
    }
    func runVisionRequest2(ciImage: CIImage, classificationRequest: VNCoreMLRequest, completionHandler: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([classificationRequest])
                completionHandler();
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
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
