//
//  MainViewModel.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 05.08.2022.
//

import Foundation

final class MainViewModel{
    
    func parse(completion:@escaping ([Device],User)->()) {
        let url = URL(string: "http://storage42.com/modulotest/data.json")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error != nil {
                print(error?.localizedDescription  ?? "error in parsing results")
                return
            }
            do{
                let result = try JSONDecoder().decode(Root.self, from: data!)
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
                Section(title: "Roller shutters", content: rollerShutters, isOpened: false),
                Section(title: "Heaters", content: heaters, isOpened: false)
            ]
            
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
    
    public func updateSection(updatedData:Any,completion:@escaping ([Section])->()){
        let defaults = UserDefaults.standard
        var sections = [Section]()
        if let lightsData = defaults.data(forKey: "lights"),
           let rollerShuttersData = defaults.data(forKey: "rollerShutters"),
           let heaterData = defaults.data(forKey: "heaters"){
            let lights = try! PropertyListDecoder().decode([Light].self, from: lightsData)
            let rollerShutters = try! PropertyListDecoder().decode([RollerShutter].self, from: rollerShuttersData)
            let heaters = try! PropertyListDecoder().decode([Heater].self, from: heaterData)
            
            sections.append(Section(title: "Light", content:lights, isOpened: true))
            sections.append(Section(title: "Roller shutters", content: rollerShutters, isOpened: false))
            sections.append(Section(title: "Heaters", content: heaters, isOpened: false))
        }
        
        var sectionCounter = 0
        var updatedContent:[Any]!
        for section in sections {
            var indexCounter = 0
            if var lights = section.content as? [Light],
               let data = updatedData as? Light {
                for light in lights{
                    if light.id == data.id {
                        break
                    }
                    indexCounter += 1
                }
                lights[indexCounter] = data
                updatedContent = lights
                
                if let lightsData = try? PropertyListEncoder().encode(lights) {
                    UserDefaults.standard.set(lightsData, forKey: "lights")
                }
            }
            else if var rollerShutters = section.content as? [RollerShutter],
                    let data = updatedData as? RollerShutter{
                for rollerShutter in rollerShutters{
                    if rollerShutter.id == data.id {
                        break
                    }
                    indexCounter += 1
                }
                rollerShutters[indexCounter] = data
                updatedContent = rollerShutters
                
                if let rollerShuttersData = try? PropertyListEncoder().encode(rollerShutters) {
                    UserDefaults.standard.set(rollerShuttersData, forKey: "rollerShutters")
                }
            }
            else if var heaters = section.content as? [Heater],
                    let data = updatedData as? Heater{
                for heater in heaters{
                    if heater.id == data.id {
                        break
                    }
                    indexCounter += 1
                }
                heaters[indexCounter] = data
                updatedContent = heaters
                
                if let heatersData = try? PropertyListEncoder().encode(heaters) {
                    UserDefaults.standard.set(heatersData, forKey: "heaters")
                }
            }else {
                sectionCounter += 1
            }
            let newSection = Section(title: section.title, content: updatedContent, isOpened: section.isOpened)
            var updatedSections = sections
            updatedSections[sectionCounter] = newSection
            print("completion with data:\(newSection)")
            completion(updatedSections)
            break
        }
    }
}
