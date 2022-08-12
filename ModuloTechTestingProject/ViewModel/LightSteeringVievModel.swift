//
//  LightSteeringVievModel.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 10.08.2022.
//

import Foundation

final class LightSteeringViewModel{

    public func saveAndSendData(data:Light,completion:@escaping (Light)->()){
        let mode:String!
        if data.mode{
             mode = "On"
        }else {
            mode = "Off"
        }
        let newLightClassObject = Light(id: data.id, name: data.name, intensity: data.intensity, mode: mode)
        
        completion(newLightClassObject)
    }
}
