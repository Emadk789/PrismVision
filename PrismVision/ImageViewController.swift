//
//  ImageViewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 15/10/2020.
//

import UIKit;
import Vision;


class ImageViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var screen: UIImageView!
    @IBOutlet weak var previewImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let image = UIImage(systemName: "star.fill");
//        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        let image = UIImage(systemName: "star.fill")
        let rect = CGRect(x: 184, y: 348, width: 36, height: 36);
//        view.addSubview(rect);
        var image = UIImage(named: "RedBlue");
        let myRect = CGRect(x: 0, y: 20, width: 15, height: 15);//Red
//        let myRect = CGRect(x: 150, y: 20, width: 15, height: 15);//Blue
        
        let image22 = image?.crop(rect: myRect);
        let cImage = CIImage(image: image22!)!;
        var image2 = image?.cgImage;
//        let rect = CGRect(x: 0, y: 0, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//        var image3 = image2?.cropping(to: rect);
//        let image4 = UIImage(cgImage: image3!);
//        let correction = 313;
//        let image5 = image?.crop(rect: CGRect(x: 184, y: 348, width: 36, height: 36));
        let imageWidth = image!.size.width;
        let imageHeight = image!.size.height;
        let screenWidth = view.bounds.width;
        let screenHeight = view.bounds.height;
        let image6 = image?.crop(rect: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight));
//        let image7 = image6?.crop(rect: CGRect(x: 30 - 36, y: 231 - 36, width: 36, height: 36));
//        image2?.cropping(to: CGRect()
//        image = UIImage(cgImage: image3!)
//        Optional(UIExtendedSRGBColorSpace 0.352941 0.152941 0.12549 1)
        print(view.bounds.height, view.bounds.width)
        print(image?.size.height, image?.size.width);
        print(image6?.size.height, image6?.size.width);
//        print("Image3", image3);
        previewImageView.image = image22;
        screen.image = image6;
//        let avg = image?.averageColor
//        if let avg = avg {
////            let red = avg.red
//            print(avg);
//        }
////        avg.
////        let color = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
//        let hex = avg!.toHexString();
//        print(hex);
//        print(hex.color())
//        let vc = UIViewController();
//        myView.backgroundColor = avg;
        let ciImage = CIImage(image: image!)!;
//        let image = UIImage(named: "gray") as! CIImage(image: )
        let request = setUp();
        runVisionRequest(ciImage: cImage, classificationRequest: request)
        
    }
    
    // MARK: - CoreML
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

extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale

        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}
