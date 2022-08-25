//
//  DeviceManager.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 23.08.2022.
//

import Foundation

final class DeviceManager{
    func getDevices(devices:[Device],completion:@escaping ([Section])->()){
        var lights = [Light]()
        var heaters = [Heater]()
        var rollerShutters = [RollerShutter]()
        
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
            // assembling sections
            let sections:[Section] = [
                Section(title: "Lights", content: lights, isOpened: true),
                Section(title: "Roller shutters", content: rollerShutters, isOpened: false),
                Section(title: "Heaters", content: heaters, isOpened: false)
            ]
            // saving sections to userDefaults
            if let LightData = try? PropertyListEncoder().encode(lights),
               let rollerShuttersData = try? PropertyListEncoder().encode(rollerShutters),
               let heatersData = try? PropertyListEncoder().encode(heaters){
                UserDefaults.standard.set(LightData, forKey: "lights")
                UserDefaults.standard.set(rollerShuttersData, forKey: "rollerShutters")
                UserDefaults.standard.set(heatersData, forKey: "heaters")
            }
            
            completion(sections)
        }
    }
