//
//  Image.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 4/5/22.
//

import Foundation
import UIKit
import SwiftUI
import SDWebImageSwiftUI

// from https://www.advancedswift.com/resize-uiimage-no-stretching-swift/
extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}


func SquareImage(url: String) -> some View {
    return GeometryReader { gr in
        WebImage(url: URL(string: url))
            .resizable()
            .scaledToFill()
            .frame(height: gr.size.width)
            .shadow(color: .black, radius: 2)
    }
    .clipped()
    .aspectRatio(1, contentMode: .fit)
    .cornerRadius(5)
}
