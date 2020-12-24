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
    var imaggaParentColor: String = "";
    var localizedLabelText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func imageUnderPointer(image resizedImage: UIImage, pointer: UIImageView) -> UIImage? {
        let imageHeight = resizedImage.size.height;
        let screenHeight = view.bounds.height;
        let correction2 = pointer.center.y * imageHeight / screenHeight;

        let rect = CGRect(x: pointer.center.x, y: correction2, width: pointer.bounds.width, height: pointer.bounds.height);

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
}
