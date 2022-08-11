//
//  extencions.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 11.08.2022.
//

import Foundation
import UIKit


extension UIView {

    var snapshot:UIImage {
        let render = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = render.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
}
