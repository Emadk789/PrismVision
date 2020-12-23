//
//  HomeAndImagePickerSuperViewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 23/10/2020.
//

import UIKit
import Vision;
import CoreML
import Alamofire

class HomeAndImagePickerSuperViewController: UIViewController {
    var coreMLLabel: String = "";
    var coreMLValue: String = "";
    var coreMLConfidence: String = "";
    var imaggaParentColor: String = "";
    var localizedLabelText: String = ""
    var request: VNCoreMLRequest!;
    override func viewDidLoad() {
        super.viewDidLoad()

        request = setUp();
    }
    
    func setUp() -> VNCoreMLRequest {
        let prisimVison = try! PrisimVision3(configuration: .init());
        
        let model = try! VNCoreMLModel(for: PrisimVision3().model)
        
        let p = try! PrisimVision5(configuration: .init());
        let m = try! VNCoreMLModel(for: p.model);
        
        let prismVision27 = try! PrisimVision27(configuration: .init());
        let model3 = try! VNCoreMLModel(for: prismVision27.model);
//        let model2 = try! VNCoreMLModel(for: PrisimVision5().model);

        let request = VNCoreMLRequest(model: model3, completionHandler: { [weak self] request, error in
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
//            self.coreMLValue = value!;
            self.coreMLConfidence = "\(confidence)";
            self.coreMLLabel = "Color: \(value!), Confidence: \(confidence) ";
//            if let classificationValue = NSLocalizedString(value!, comment: "") {
//
//            }
//            TODO: Replace the value with with the value returned from the API. Use the same NSLoclizedString(_, comment:) method
            self.coreMLValue = NSLocalizedString(value!, comment: "");
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
    
    
    public func getColors(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        ImaggaClient.shared.getUploadID(data: imageData, for: UploadResponse.self, completion: self.handleGetUploadID(response:error:))
        
    }
    private func handleGetUploadID(response: UploadResponse?, error: Error?) {
        if let response = response {
            ImaggaClient.shared.getColors(uploadID: response.result.uploadId, for: GetColorsResponse.self, completion: self.handleGetColors(result:error:))
        }
        //TODO: Show Error Message!
    }
    private func handleGetColors(result: GetColorsResponse?, error: Error?) {
        if let result = result {
            // Get the color with the highest persentage, i.e., index 0.
            imaggaParentColor = result.result.colors.imageColors[0].closestPaletteColorParent
            updateLabel()
        }
        //TODO: Show Error Message!
    }
    // This function is overriden in the subclasses
    func updateLabel() {
        let formatString = NSLocalizedString("Color: %@", comment: "Classification Lable");
        let localizedColorName = NSLocalizedString(self.imaggaParentColor.capitalized, comment: "")
        localizedLabelText =  String.localizedStringWithFormat(formatString, localizedColorName);
        
    }
    private func getImageID(image: UIImage, completion: @escaping (UploadResponse?, Error?) -> Void) {
        print("This is after", image.size.width, image.size.height)
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            print("Could not get JPEG representation of UIImage")
            return
          }
        
        AF.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(imageData.base64EncodedData(), withName: "image")
            multipartFormData.append(Data(base64Encoded: imageData.base64EncodedData())!, withName: "image")
//            multipartFormData.append(imageData, withName: "imagefile", fileName: "image.jpeg", mimeType: "image/jpeg")
        }, to: "https://api.imagga.com/v2/uploads", headers: ["Authorization": "Basic YWNjX2MyMWUwMTExZTZlOGRkYzpkZjE1NTVmZGYzMTA4ZDczMzJiN2JmMzA3YmM4YTVlYg=="]).responseData { (response) in
//            guard let data = response else {
//                return
//            }
//            let x = response.
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let result = try! decoder.decode(UploadResponse.self, from: response.data!)
            let uploadId = result.result.uploadId
            completion(result, nil)
            
            debugPrint(response)
        }
    }
//    i14ce3342b91487d4ef6b116e9y44uFZ
//    i1486e9bb77eaf3c0e8bb9246eKq8cou
//    i1410cd72c12e23dee2fbcfc0ausbcTA
    private func downloadeColors(uploadId: String? = nil) {
        AF.request("https://api.imagga.com/v2/colors", parameters: ["image_upload_id": uploadId ?? "i15e26d77f6fd90fdc510acb06kJLVNu", "language": "ar"], headers: ["Authorization": "Basic YWNjX2MyMWUwMTExZTZlOGRkYzpkZjE1NTVmZGYzMTA4ZDczMzJiN2JmMzA3YmM4YTVlYg=="]).responseJSON { (response) in
            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let result = try! decoder.decode(GetColorsResponse.self, from: response.data!)
            let imageColors = result.result.colors.imageColors
//            TODO: You need to show this color in the label
//            Use NSLoclizedString(_, comment:) method as in line 61 to use the Localizable.strings files
//            self.coreMLValue and coreMLConfidence are the variables used to show the ML results.
//            You can delete the confidance level from the label and the 
            let color = result.result.colors.imageColors[0].closestPaletteColorParent
            print(response)
        }
    }
    

}
