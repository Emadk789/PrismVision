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
    var imaggaParentColor2: String = ""
    var localizedLabelText: String = ""
    var closestPaletteColorHTMLCode: UIColor?
    var paletteHexStringCode: String = ""
    
    var testImage2: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func imageUnderPointer(image resizedImage: UIImage, pointer: UIImageView) -> UIImage? {
        let imageHeight = resizedImage.size.height;
        let screenHeight = view.bounds.height;
        let correction2 = pointer.center.y * imageHeight / screenHeight;

        let rect = CGRect(x: pointer.frame.minX, y: pointer.frame.minY, width: pointer.bounds.width, height: pointer.bounds.height);

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
            let color = hexStringToUIColor(hex: result.result.colors.imageColors[0].closestPaletteColorHTMLCode)
            imaggaParentColor2 = result.result.colors.imageColors[0].closestPaletteColor
            paletteHexStringCode = result.result.colors.imageColors[0].closestPaletteColorHTMLCode
            print("imaggaParentColor2", imaggaParentColor2)
            closestPaletteColorHTMLCode = color
            updateLabel()
        }
        //TODO: Show Error Message!
    }
    // This function is overriden in the subclasses
    func updateLabel() {
        let formatString = NSLocalizedString("Color: %@", comment: "Classification Lable");
        let localizedColorName = NSLocalizedString(self.imaggaParentColor2, comment: "")
        print("localizedColorName", localizedColorName)
        localizedLabelText =  String.localizedStringWithFormat(formatString, localizedColorName).capitalized + "  |  \(paletteHexStringCode)";
        
//        let vc = storyboard?.instantiateViewController(identifier: "Preview") as! PhotoPreviewView
//        
//        vc.image = testImage2
//        present(vc, animated: true, completion: nil)
        
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
