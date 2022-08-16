//
//  LightSteeringVievModel.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 10.08.2022.
//

import Foundation
//MARK: Get updated data, assem
final class SteeringViewModel{
    
    public func saveAndSendLightObject(model:Light,updatedMode:Bool,updatedValue:Int,completion:@escaping (Light)->()){
        let mode:String
        if  updatedMode{
            mode = "ON"
        }else {
            mode = "OFF"
        }
            let newLightClassObject = Light(id: model.id, name: model.name, intensity: updatedValue, mode: mode)
            completion(newLightClassObject)
    }
    
    public func saveAndSendRollerShutterObject(model:RollerShutter,updatedValue:Int,completion:@escaping (RollerShutter)->()){
        
            let newRollerShutter = RollerShutter(id: model.id, name: model.name, position: updatedValue)
            completion(newRollerShutter)
    }
    
    public func saveAndSendHeaterObject(model:Heater,updatedMode:Bool,updatedValue:Double,completion:@escaping (Heater)->()){
        
        let mode:String
        if  updatedMode{
            mode = "ON"
        }else {
            mode = "OFF"
        }
   
            let newHeaterObkect = Heater(id: model.id, name: model.name, temp: updatedValue, mode: mode)
            completion(newHeaterObkect)
    }
}
