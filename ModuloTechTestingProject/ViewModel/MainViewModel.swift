//
//  MainViewModel.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 05.08.2022.
//

import Foundation
import UIKit

final class MainViewModel{
    
    func parse(completion:@escaping ([Device],User)->()) {
        let url = URL(string: "http://storage42.com/modulotest/data.json")
         
         URLSession.shared.dataTask(with: url!) { data, response, error in
             if error != nil {
                 print(error?.localizedDescription  ?? "error in parsing results")
                 return
             }
                 do{
                 let result = try JSONDecoder().decode(Welcome.self, from: data!)
                     completion(result.devices,result.user)
                 }catch {
                     print("error")
                 }
         }.resume()
    }
    
    func getDevices(completion:@escaping ([Section])->()){
        var lights = [Light]()
        var heaters = [Heater]()
        var rollerShutters = [RollerShutter]()
        parse { devices, user in
            for device in devices {
                if let position = device.position{
                    let rollerShutter = RollerShutter(id: device.id, name: device.deviceName, position: position)
                   
                    rollerShutters.append(rollerShutter)
    
                }else if let temperature = device.temperature,
                         let mode = device.mode{
                    let heater = Heater(id: device.id, name: device.deviceName, temp: temperature, mode: mode)
                  
                    heaters.append(heater)
                
                }else if let intensity = device.intensity,
                         let mode = device.mode{
                    let light = Light(id: device.id, name: device.deviceName, intensity: intensity, mode:mode)
                    
                    lights.append(light)
                }
            }
            let sections:[Section] = [
                Section(title: "Lights", content: lights, isOpened: true),
                Section(title: "Roller shutters", content: rollerShutters, isOpened: true),
                Section(title: "Heaters", content: heaters, isOpened: false)
            ]
            
            completion(sections)
        }
    }
    
}
