//
//  ImageHelper.swift
//  CoreML
//
//  Created by Joshua Sullivan on 9/6/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//

import UIKit
import CoreImage

/// A simple, static class for resizing images to the preferred size.
final class ImageHelper {
    
    /// The throwing functions of this class will all throw this error type.
    enum RenderError: Error {
        /// The ImageHelper failed to create an image suitable for use with the model.
        case unableToResizeImage
    }
    
    /// Try to create a hardware accelerated CIContext, but using the CPU is okay, too.
    private static let ctx: CIContext = {
        guard let eagl = EAGLContext(api: .openGLES2) else {
            debugPrint("WARNING: OpenGL context could not be created. Using CPU for rendering.")
            return CIContext()
        }
        return CIContext(eaglContext: eagl)
    }()
    
    /// Resize a UIImage and convert it to a CVPixelBuffer for use with the model.
    /// - Parameter image: The UIImage to be normalized and converted.
    /// - Parameter size: The pixel dimension of the output (models almost always use square input).
    /// - Returns: A CVPixelBuffer containing the resized and cropped image.
    static func resizeForInput(image: UIImage, size: Int) throws -> CVPixelBuffer {
        guard let ci = CIImage(image: image) else {
            throw RenderError.unableToResizeImage
        }
        return try resizeForInput(image: ci, size: size)
    }
    
    /// Resize a CIImage and convert it to a CVPixelBuffer for use with the model.
    /// - Parameter image: The CIImage to be normalized and converted.
    /// - Parameter size: The pixel dimension of the output (models almost always use square input).
    /// - Returns: A CVPixelBuffer containing the resized and cropped image.
    static func resizeForInput(image: CIImage, size: Int) throws -> CVPixelBuffer {
        let finalImage = scaleAndCrop(image: image, to: size)
        return try renderToPixelBuffer(image: finalImage)
    }
    
    /// Scale and crop an image using the Aspect Fill strategy.
    private static func scaleAndCrop(image: CIImage, to size: Int) -> CIImage {
        let fSize = CGFloat(size)
        let scaleFactor = max(fSize / image.extent.width, fSize / image.extent.size.height)
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let scaledImage = image.transformed(by: scaleTransform)
        let dx = floor((scaledImage.extent.width - fSize) / 2.0)
        let dy = floor((scaledImage.extent.height - fSize) / 2.0)
        let croppedImage = scaledImage.cropped(to: CGRect(x: dx, y: dy, width: fSize, height: fSize))
        let rezeroTransform = CGAffineTransform(translationX: -dx, y: -dy)
        let finalImage = croppedImage.transformed(by: rezeroTransform)
        return finalImage
    }
    
    /// Create a CVPixelBuffer and render the image to it.
    private static func renderToPixelBuffer(image: CIImage) throws -> CVPixelBuffer {
        let attributes: NSDictionary = [
            kCVPixelBufferIOSurfacePropertiesKey : [:]
        ]
        
        var pixelBuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault,
                            Int(image.extent.width),
                            Int(image.extent.height),
                            kCVPixelFormatType_32BGRA,
                            attributes,
                            &pixelBuffer)
        guard let pb = pixelBuffer else {
            throw RenderError.unableToResizeImage
        }
        ctx.render(image, to: pb)
        return pb
    }
}
