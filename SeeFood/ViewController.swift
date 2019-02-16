//
//  ViewController.swift
//  SeeFood
//
//  Created by Haoran Hu on 2/16/19.
//  Copyright © 2019 hhr. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD
import Social


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let version = "2019-02-16"
    
    var classificationResult :[String] = []
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func sharePressed(_ sender: UIButton) {
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
//            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//            vc?.setInitialText("this is a \(navigationItem,title)")
////            vc?.add(<#T##image: UIImage!##UIImage!#>)
//            present(vc!,animated: true,completion: nil)
//        } else{
//            self.navigationItem.title = "plz log in to twitter"
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        shareButton.isHidden = true
        self.view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.navigationItem.title = ""
        self.cameraButton.isEnabled = false
        SVProgressHUD.show()
        
        if let image = info[UIImagePickerController.InfoKey.originalImage ] as? UIImage{
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRevognition = VisualRecognition(version: version, apiKey: apiKey)
            
            let imageData = image.jpegData(compressionQuality: 0.01)
            
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let fileURL = documentURL.appendingPathComponent("tempImage.jpg")
            
            try? imageData?.write(to: fileURL, options: [])
    
            visualRevognition.classify(image: image) { (RestResponse, error) in
                print("======\n\(RestResponse?.result?.images.first?.classifiers.first?.classes.first?.className ?? " ")\n========\n")
                
                self.classificationResult = []
                let classes = RestResponse?.result?.images.first?.classifiers.first?.classes
                for index in 0..<classes!.count {
                    self.classificationResult.append(classes![index].className )
                }
                print(self.classificationResult)
                
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.cameraButton.isEnabled = true
                    self.navigationItem.title = self.classificationResult[0]
//                    self.shareButton.isHidden = false
                }
                
                
            }
            
            
        }else{
            print("error picking the image")
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
}

