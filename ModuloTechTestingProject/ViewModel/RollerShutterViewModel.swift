//
//  RollerShutterViewModel.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 25.08.2022.
//

import Foundation
struct RollerShutterCellViewModel{
     var device:RollerShutter
    
    public func saveAndSendRollerShutterObject(updatedValue:Int,completion:@escaping (RollerShutter)->()){
        
            let newRollerShutter = RollerShutter(id: device.id, name: device.name, position: updatedValue)
            completion(newRollerShutter)
    }

}
