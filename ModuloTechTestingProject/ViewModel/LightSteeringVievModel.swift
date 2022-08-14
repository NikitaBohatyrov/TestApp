//
//  LightSteeringVievModel.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 10.08.2022.
//

import Foundation

final class SteeringViewModel{
    
    public func saveAndSendData(model:Any,updatedMode:Bool,updatedValue:Int,completion:@escaping (Light)->()){
        let mode:String
        if updatedMode{
            mode = "ON"
        }else {
            mode = "OFF"
        }
        if let model = model as? Light{
            let newLightClassObject = Light(id: model.id, name: model.name, intensity: updatedValue, mode: mode)
            completion(newLightClassObject)
        }
    }
}
