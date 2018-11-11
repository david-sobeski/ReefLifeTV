//
//  UIImage+Extension.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/4/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import UIKit

//
//  This extension allows us to resize an image to a much smaller size in memory.
//
extension UIImage
{
    //
    //  Given a rectangle's bounds (width and height), resize the image.
    //
    func resizeTo(_ rect: CGRect) -> UIImage
    {
        //
        //  Set the new size of our image.
        //
        let width = Int(rect.width)
        let height = Int(rect.height)
        //
        //  Create a new bitmap image based on our internal image.
        //
        let bitsPerComponent = self.cgImage?.bitsPerComponent
        let bytesPerRow = self.cgImage?.bytesPerRow
        let colorSpace = self.cgImage?.colorSpace
        let bitmapInfo = self.cgImage?.bitmapInfo
        
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent!, bytesPerRow: bytesPerRow!, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
        context!.interpolationQuality = CGInterpolationQuality.high
        context?.draw(self.cgImage!, in: CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(width), height: CGFloat(height))))
        
        //
        //  Create and return our newly resized image.
        //
        let scaledImage = context?.makeImage().flatMap { UIImage(cgImage: $0) }
        
        return scaledImage!
    }
}
