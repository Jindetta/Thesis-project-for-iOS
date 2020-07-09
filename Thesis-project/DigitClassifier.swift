//
//  DigitClassifier.swift
//  Thesis-project
//
//  Created by Joonas Lauhala on 8.7.2020.
//  Copyright © 2020 Joonas Lauhala. All rights reserved.
//
import UIKit
import Vision

protocol ClassificationResultListener {
    func OnClassificationReceived(classification: DigitClassifier.Classification?)
}

class DigitClassifier {
    
    var classificationResultDelegate: ClassificationResultListener?
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        let model = try! VNCoreMLModel(for: MNISTClassifier().model)
        
        return VNCoreMLRequest(model: model, completionHandler:{request, error in
            let classification = Classification((request.results as? [VNClassificationObservation])?.first)
            self.classificationResultDelegate?.OnClassificationReceived(classification: classification)
        })
    }()
    
    func classify(image: CIImage) {
        DispatchQueue.global(qos:.userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: image, orientation: CGImagePropertyOrientation.up)
            
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                self.classificationResultDelegate?.OnClassificationReceived(classification: nil)
            }
        }
    }
    
    class Classification {
        let confidence: Float
        let result: String
        
        init?(_ classification: VNClassificationObservation?) {
            if let classification = classification {
                self.confidence = classification.confidence
                self.result = classification.identifier
            } else {
                return nil
            }
        }
    }
}
