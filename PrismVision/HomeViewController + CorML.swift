//
//  HomeViewController + CorML.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 19/10/2020.
//
import Vision;
import UIKit;
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
        let confidence = ((classifications.first?.confidence)! as Float) * 100;
//        print("pointerLocation", pointer.center);
        DispatchQueue.main.async {
            self.label.text = "Color: \(value!), Confidence: \(confidence) ";
            print(value!, confidence);
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
    func processClassifications2(for request: VNRequest, error: Error?, completionHandler: @escaping () -> Void) {
    //
            var classificationLabel = "";
            guard let results = request.results else {
                classificationLabel = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation];
            let value = classifications.first?.identifier;
        let confidence = ((classifications.first?.confidence)! as Float) * 100;
    //        print("pointerLocation", pointer.center);
        DispatchQueue.main.async {
            self.label.text = "Color: \(value!), Confidence: \(confidence) ";
            print(value!, confidence);
            completionHandler();
        }
    //        correctPointerLocation();
    }
    //    func correctPointerLocation() {
    //        DispatchQueue.main.async {
    //            print("pointerLocation2", self.pointer.center);
    //        }
    //    }

}
