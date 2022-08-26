//
//  LightVIewModel.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 25.08.2022.
//

import Foundation
struct LightCellViewModel{
    var device:Light
    
    
    public func saveAndSendLightObject(updatedMode:Bool,updatedValue:Int,completion:@escaping (Light)->()){
        let mode:String
        if  updatedMode{
            mode = "ON"
        }else {
            mode = "OFF"
        }
            let newLightClassObject = Light(id: device.id, name: device.name, intensity: updatedValue, mode: mode)
            completion(newLightClassObject)
    }
}
