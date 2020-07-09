//
//  DrawableView.swift
//  Thesis-project
//
//  Created by Joonas Lauhala on 8.7.2020.
//  Copyright © 2020 Joonas Lauhala. All rights reserved.
//

import UIKit

class DrawableView: UIImageView {

    var lastPoint = CGPoint.init()
    var brushColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    var brushWidth: CGFloat = 25.0
    
    // MARK: Overridden functions
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.image = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    // MARK: Public functions
    
    func getCurrentImage() -> CIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 28, height: 28), false, 1.0)
        self.image?.draw(in: CGRect(x: 0, y: 0, width: 28, height: 28))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = scaledImage?.cgImage else {
            return nil
        }
        
        return CIImage(cgImage: cgImage)
    }
    
    func isEmptyCanvas() -> Bool {
        return self.image == nil
    }
    
    // MARK: Private functions
    
    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            self.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
        
            context.setLineCap(CGLineCap.round)
            context.setLineWidth(brushWidth)
            
            context.setStrokeColor(brushColor)
            context.setBlendMode(CGBlendMode.normal)
        
            context.strokePath()
            
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            self.alpha = brushColor.alpha
        }
        UIGraphicsEndImageContext()
    }
}
