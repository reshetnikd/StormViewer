//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Dmitry Reshetnik on 20.02.2020.
//  Copyright © 2020 Dmitry Reshetnik. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    var selectedPictureNumber = 0
    var selectedCounter = 0
    var totalPictures = 0
    var imageSize: CGSize = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        selectedCounter = defaults.object(forKey: "\(selectedPictureNumber)") as? Int ?? 0
        title = "Picture \(selectedPictureNumber) of \(totalPictures)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.largeTitleDisplayMode = .never
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
            imageSize = imageView.image!.size
        }
        selectedCounter += 1
        defaults.set(selectedCounter, forKey: "\(selectedPictureNumber)")
        
        assert(selectedImage != nil, "Image is always must be selected.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let _ = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: imageSize.width + 20, height: imageSize.height + 40))
        
        let shareImage = renderer.image { (ctx) in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 17, weight: .heavy),
                .paragraphStyle: paragraphStyle
            ]
            
            let attributedString = NSAttributedString(string: selectedImage!, attributes: attributes)
            imageView.image?.draw(at: CGPoint(x: 10, y: 30))
            attributedString.draw(with: CGRect(x: 10, y: 10, width: imageSize.width, height: 25), options: .usesLineFragmentOrigin, context: nil)
        }
        
        let vc = UIActivityViewController(activityItems: [shareImage.jpegData(compressionQuality: 0.8)!, selectedImage!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
