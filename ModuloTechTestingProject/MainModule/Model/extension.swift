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

extension String {
    func localized()->String{
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
    
    func localizedWithParameters(_ parameters:CVarArg...)->String{
       
        let localizedString = self.localized()
        return String(format: localizedString, parameters)
                      
    }
}
