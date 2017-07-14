//
//  Splash.swift
//  teamAppic
//
//  Created by Richard Vaz da Silva Netto on 03/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Splash{
    let SPLASHSIZE : CGFloat = 15
    var splashTexture: SKTexture!
    
    init(imageNamed: String, targetRect: CGRect, splashPosition: CGPoint, targetType: TargetType) {
        let image:UIImage!
        switch targetType {
        case .target:
            image = cropCircleImage(imageName: imageNamed, targetRect: targetRect, splashPosition: splashPosition)
        default:
            image = cropSquareImage(imageName: imageNamed, targetRect: targetRect, splashPosition: splashPosition)
        }
        splashTexture = SKTexture(image: image)
        
    }
    
    ///		Function that draw an image in a fixed croped area.
    ///
    /// - Parameters:
    ///   - imageName: String
    ///   - targetRect: CGRect
    ///   - splashPosition: CGPoint
    func cropCircleImage(imageName: String, targetRect: CGRect, splashPosition: CGPoint) -> UIImage{
        UIGraphicsBeginImageContext(targetRect.size)
        
        // graphic context
        let ctx:CGContext! = UIGraphicsGetCurrentContext()
        
        // adds path clip to ensure the image only stays in the target
        let r:CGFloat = targetRect.size.width/2
        var x:CGFloat = targetRect.size.width/2
        var y:CGFloat = targetRect.size.width/2
        let clipPath = UIBezierPath()
        clipPath.addArc(withCenter: CGPoint(x: x, y: y), radius: r, startAngle: 0, endAngle: 360, clockwise: true)
        clipPath.addClip()
        
        
        // adds image to the desired position
        ctx.saveGState()
        let splashImage: UIImage! = UIImage(named: imageName)
        let sizeDiff:CGFloat = SPLASHSIZE
        x = splashPosition.x + sizeDiff/2
        y = -splashPosition.y + sizeDiff/2
        let w:CGFloat = targetRect.size.width - sizeDiff
        let h:CGFloat = targetRect.size.width - sizeDiff
        splashImage.draw(in: CGRect(x: x, y: y, width: w, height: h))
        
        // Saves the Context to an Image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
    ///		Function that draw an image in a fixed croped area.
    ///
    /// - Parameters:
    ///   - imageName: String
    ///   - targetRect: CGRect
    ///   - splashPosition: CGPoint
    func cropSquareImage(imageName: String, targetRect: CGRect, splashPosition: CGPoint) -> UIImage{
        UIGraphicsBeginImageContext(targetRect.size)
        
        // graphic context
        let ctx:CGContext! = UIGraphicsGetCurrentContext()
        
        // adds path clip to ensure the image only stays in the target
        var x:CGFloat = targetRect.size.width
        var y:CGFloat = targetRect.size.height
        let clipPath = UIBezierPath()
        clipPath.addLine(to: CGPoint(x: 0, y: 0))
        clipPath.addLine(to: CGPoint(x: x, y: 0))
        clipPath.addLine(to: CGPoint(x: x, y: -y))
        clipPath.close()
        clipPath.addClip()
        
        
        // adds image to the desired position
        ctx.saveGState()
        let splashImage: UIImage! = UIImage(named: imageName)
        let sizeDiff:CGFloat = SPLASHSIZE
        x = splashPosition.x + sizeDiff/2
        y = -splashPosition.y + sizeDiff/2
        let w:CGFloat = targetRect.size.width - sizeDiff
        let h:CGFloat = targetRect.size.width - sizeDiff
        splashImage.draw(in: CGRect(x: x, y: y, width: w, height: h))
        
        // Saves the Context to an Image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
}
