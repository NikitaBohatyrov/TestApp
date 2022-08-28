//
//  UserDefaultsManager.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 26.08.2022.
//

import Foundation
protocol SavingToUserDefaultsProtocol{
    static func saveLights(_ lights:[Light])->()
    static func saveRollerShutters(_ rollers:[RollerShutter])->()
    static func saveHeaters(_ heaters:[Heater])->()
    static func saveAll(_ lights:[Light],_ rollers:[RollerShutter],_ heaters:[Heater])->()
}


protocol ExtractingFromUserDefaultsProtocol{
    static  func get(completion:@escaping ((Result<[Section],Error>) ->()))
}

struct UserDefaultsManager:SavingToUserDefaultsProtocol,ExtractingFromUserDefaultsProtocol {
    
    static func get(completion: @escaping ((Result<[Section], Error>) -> ())) {
        let defaults = UserDefaults.standard
        var sections = [Section]()
        
        if let lightsData = defaults.data(forKey: "lights"),
           let rollerShuttersData = defaults.data(forKey: "rollerShutters"),
           let heaterData = defaults.data(forKey: "heaters"){
            let lights = try! PropertyListDecoder().decode([Light].self, from: lightsData)
            let rollerShutters = try! PropertyListDecoder().decode([RollerShutter].self, from: rollerShuttersData)
            let heaters = try! PropertyListDecoder().decode([Heater].self, from: heaterData)
            
            sections.append(Section(title: "Lights", content:lights, isOpened: false))
            sections.append(Section(title: "Roller shutters", content: rollerShutters, isOpened: false))
            sections.append(Section(title: "Heaters", content: heaters, isOpened: false))
        
            completion(.success(sections))
        }
    }
    
    static func manageLights(device:Light){
        let defaults = UserDefaults.standard
        var updatedArray = [Light]()
        if let data = defaults.data(forKey: "lights"){
            var array = try! PropertyListDecoder().decode([Light].self, from: data)
            
            if let elementToSubstitute = array.first(where:{$0.id == device.id }),
               let indexOfsubstittutable = array.firstIndex(where:{$0 === elementToSubstitute}){
                array[indexOfsubstittutable] = device
                updatedArray = array
                
              saveLights(updatedArray)
            }else {
                return
            }
        }else {
            return
        }
    }
    
    static func manageRollerShutters(device:RollerShutter){
        let defaults = UserDefaults.standard
        var updatedArray = [RollerShutter]()
        if let data = defaults.data(forKey: "rollerShutters"){
            var array = try! PropertyListDecoder().decode([RollerShutter].self, from: data)
            
            if let elementToSubstitute = array.first(where:{$0.id == device.id }),
               let indexOfsubstittutable = array.firstIndex(where:{$0 === elementToSubstitute}){
                array[indexOfsubstittutable] = device
                updatedArray = array
                
               saveRollerShutters(updatedArray)
            }else {
                return
            }
        }else {
            return
        }
    }
    
    static func manageHeaters(device:Heater){
        let defaults = UserDefaults.standard
        var updatedArray = [Heater]()
        if let data = defaults.data(forKey: "heaters"){
            var array = try! PropertyListDecoder().decode([Heater].self, from: data)
            
            if let elementToSubstitute = array.first(where:{$0.id == device.id }),
               let indexOfsubstittutable = array.firstIndex(where:{$0 === elementToSubstitute}){
                array[indexOfsubstittutable] = device
                updatedArray = array
                
             saveHeaters(updatedArray)
            }else {
                return
            }
        }else {
            return
        }
    }
    
   static func saveLights(_ lights:[Light]){
       if let LightData = try? PropertyListEncoder().encode(lights){
           UserDefaults.standard.set(LightData, forKey: "lights")
       }
    }
    
    static func saveRollerShutters(_ rollers:[RollerShutter]){
        if   let rollerShuttersData = try? PropertyListEncoder().encode(rollers){
            UserDefaults.standard.set(rollerShuttersData, forKey: "rollerShutters")
        }
    }
    
    static func saveHeaters(_ heaters:[Heater]){
        if  let heatersData = try? PropertyListEncoder().encode(heaters){
            UserDefaults.standard.set(heatersData, forKey: "heaters")
        }
    }
    
    static func saveAll(_ lights:[Light],_ rollers:[RollerShutter],_ heaters:[Heater]){
        saveLights(lights)
        saveHeaters(heaters)
        saveRollerShutters(rollers)
    }
}
