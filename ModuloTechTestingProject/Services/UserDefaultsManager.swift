//
//  UserDefaultsManager.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 26.08.2022.
//

import Foundation
protocol SavingToUserDefaultsProtocol{
    static func save(_ lights:[Light],_ rollerShutters:[RollerShutter],_ heaters:[Heater])->()
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

    static func save(_ lights: [Light], _ rollerShutters: [RollerShutter], _ heaters: [Heater]) {
        if let LightData = try? PropertyListEncoder().encode(lights),
           let rollerShuttersData = try? PropertyListEncoder().encode(rollerShutters),
           let heatersData = try? PropertyListEncoder().encode(heaters){
            UserDefaults.standard.set(LightData, forKey: "lights")
            UserDefaults.standard.set(rollerShuttersData, forKey: "rollerShutters")
            UserDefaults.standard.set(heatersData, forKey: "heaters")
        }
    }
}
