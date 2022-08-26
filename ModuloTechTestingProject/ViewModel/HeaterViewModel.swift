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
}
