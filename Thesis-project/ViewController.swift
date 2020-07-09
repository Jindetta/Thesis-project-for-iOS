//
//  ViewController.swift
//  Thesis-project
//
//  Created by Joonas Lauhala on 21.2.2020.
//  Copyright © 2020 Joonas Lauhala. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ClassificationResultListener {
    
    let digitClassifier = DigitClassifier()
    
    @IBOutlet weak var drawingComponent: DrawableView!
    @IBOutlet weak var infoComponent: UILabel!
    
    // MARK: Overridden functions
    
    override func viewDidLoad() {
        digitClassifier.classificationResultDelegate = self
    }
    
    // MARK: Storyboard event handlers
    
    @IBAction func onClassifyClicked(_ sender: Any) {
        if !drawingComponent.isEmptyCanvas() {
            if let image = drawingComponent.getCurrentImage() {
                digitClassifier.classify(image: image.applyingFilter("CIColorInvert"))
            }
        }
    }
    
    @IBAction func onClearClicked(_ sender: Any) {
        drawingComponent.image = nil
        OnClassificationReceived(classification: nil)
    }
    
    // MARK: ClassificationResultListener implementation
    
    func OnClassificationReceived(classification: DigitClassifier.Classification?) {
        DispatchQueue.main.async {
            if let results = classification {
                self.infoComponent.text = String(format: "Classification: %.3f - Result: %@", results.confidence,  results.result)
            } else {
                self.infoComponent.text = "Classification: N/A - Result: N/A"
            }
        }
    }
}
