//
//  ViewController.swift
//  Thesis-project
//
//  Created by Joonas Lauhala on 21.2.2020.
//  Copyright © 2020 Joonas Lauhala. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    var lastPoint = CGPoint.init()
    var brushColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    var brushWidth: CGFloat = 25.0
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        let model = try! VNCoreMLModel(for: MNISTClassifier().model)
        
        return VNCoreMLRequest(model: model, completionHandler:{request, error in
            self.updateView((request.results as? [VNClassificationObservation])?.first)
        })
    }()
    
    @IBOutlet weak var drawingComponent: UIImageView!
    @IBOutlet weak var infoComponent: UILabel!
    
    // MARK: Overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastPoint = touch.location(in: drawingComponent)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: drawingComponent)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    // MARK: Event handlers
    
    @IBAction func onClassifyClicked(_ sender: Any) {
        if let image = convertCurrentImage() {
            DispatchQueue.global(qos:.userInitiated).async {
                let handler = VNImageRequestHandler(ciImage: image, orientation: CGImagePropertyOrientation.up)
                
                do {
                    try handler.perform([self.classificationRequest])
                } catch {
                    self.updateView(nil)
                }
            }
        }
    }
    
    @IBAction func onClearClicked(_ sender: Any) {
        drawingComponent.image = nil
        updateView(nil)
    }
    
    // MARK: Private functions
    
    private func updateView(_ results: VNClassificationObservation?) {
        DispatchQueue.main.async {
            if let resultData = results {
                self.infoComponent.text = String(format: "Classification: %.3f - Result: %@", resultData.confidence,  resultData.identifier)
            } else {
                self.infoComponent.text = "Classification: N/A - Result: N/A"
            }
        }
    }
    
    private func convertCurrentImage() -> CIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 28, height: 28), false, 1.0)
        drawingComponent.image?.draw(in: CGRect(x: 0, y: 0, width: 28, height: 28))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = scaledImage?.cgImage else {
            return nil
        }
        
        return CIImage(cgImage: cgImage).applyingFilter("CIColorInvert")
    }
    
    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(drawingComponent.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            drawingComponent.image?.draw(in: CGRect(x: 0, y: 0, width: drawingComponent.frame.size.width, height: drawingComponent.frame.size.height))
            
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
        
            context.setLineCap(CGLineCap.round)
            context.setLineWidth(brushWidth)
            
            context.setStrokeColor(brushColor)
            context.setBlendMode(CGBlendMode.normal)
        
            context.strokePath()
            
            drawingComponent.image = UIGraphicsGetImageFromCurrentImageContext()
            drawingComponent.alpha = brushColor.alpha
        }
        UIGraphicsEndImageContext()
    }
}

