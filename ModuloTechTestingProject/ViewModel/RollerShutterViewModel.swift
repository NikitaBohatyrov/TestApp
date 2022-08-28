//
//  RollerShutterViewModel.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 25.08.2022.
//

import Foundation
import UIKit
struct RollerShutterCellViewModel{
     var device:RollerShutter
    
    public func updatePositionUI(_ value:Float,completion:@escaping (Int,UIImage,String?,UIColor)->()){
       print(value)
        let valueToChange = Int(value*100)
        let image:UIImage!
        var positionString:String?
        
        switch valueToChange{
        case 0:
           image = UIImage(named: "DeviceRollerShutterOpenedIcon")
            positionString = "Opened".localized()
        case 100:
            image = UIImage(named: "DeviceRollerShutterClosedIcon")
           positionString = "Closed".localized()
        default:
            image = UIImage(named: "DeviceRollerShutterIcon")
        }
        
        updateBackGroundView(value: value) { color in
           let backgroundColor = color
            completion(valueToChange,image,positionString ?? "",backgroundColor)
        }
    }
    
    private func updateBackGroundView(value:Float, completion:@escaping (UIColor)->()){
        let greenValue = CGFloat(86 - Int(value*50))
        let blueValue = CGFloat(118 - Int(value*50))
       let backGroundColor = UIColor(red: 36/255,
                                            green: greenValue/255,
                                            blue: blueValue/255, alpha: 1)
        completion(backGroundColor)
    }
    
    public func saveAndSendRollerShutterObject(updatedValue:Int,completion:@escaping (RollerShutter)->()){
        
            let newRollerShutter = RollerShutter(id: device.id, name: device.name, position: updatedValue)
            completion(newRollerShutter)
    }

}
