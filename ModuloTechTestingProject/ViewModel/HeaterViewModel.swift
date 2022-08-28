//
//  HeaterViewModel.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 25.08.2022.
//

import Foundation
struct HeaterCellViewModel{
    var device:Heater
    
    public func saveAndSendHeaterObject(updatedMode:Bool,updatedValue:Double,completion:@escaping (Heater)->()){
        
        let mode:String
        if  updatedMode{
            mode = "ON"
        }else {
            mode = "OFF"
        }
   
            let newHeaterObkect = Heater(id: device.id, name: device.name, temp: updatedValue, mode: mode)
            completion(newHeaterObkect)
    }
    
    public func increaseTemperature(_ temperature:Double, completion:@escaping (Double)->()){
        var updatedTemp = temperature
        if  updatedTemp < 28 {
            updatedTemp += 0.5
           completion(updatedTemp)
        }
    }
    
    public func decreaseTemperature(_ temperature:Double, completion:@escaping (Double)->()){
        var updatedTemp = temperature
        if updatedTemp > 7 {
            updatedTemp -= 0.5
           completion(updatedTemp)
        }
    }
}
