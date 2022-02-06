//
//  Image.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import Foundation
import UIKit

// wrapper around UIImage
public class CameraOutput: ObservableObject {
    @Published public var image: UIImage? = nil
    init(){
    }
}
