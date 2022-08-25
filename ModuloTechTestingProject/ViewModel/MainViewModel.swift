//
//  MainViewModel.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 05.08.2022.
//

import Foundation

final class MainViewModel{
    
    var sections:(([Section])->Void)?
    
    public func loadView(){
        Parser().parse {[weak self] parsedResult in
            DeviceManager().getDevices(devices: parsedResult) { [weak self] sortedDevices in
                self?.sections?(sortedDevices)
            }
        }
    }
    
    // MARK: Updates Sections with given updated data and saves it to userDefaults, and throws updated Sections
    public func updateSection(updatedData:Any,completion:@escaping ([Section])->()){
       
       
        getSectionsFromUserDefault { result in
            switch result {
            case .success(var sections):
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
                        // saving new sections data to userDefaults
                        if let lightsData = try? PropertyListEncoder().encode(lights) {
                            UserDefaults.standard.set(lightsData, forKey: "lights")
                        }
                        
                        let newSection = Section(title: section.title, content: updatedContent, isOpened: true)
                       
                        sections[sectionCounter] = newSection
                        // complete sections update
                        completion(sections)
                    }
                    else if var rollerShutters = section.content as? [RollerShutter],
                            let data = updatedData as? RollerShutter {
                        for rollerShutter in rollerShutters{
                            if rollerShutter.id == data.id {
                                break
                            }
                            indexCounter += 1
                        }
                        rollerShutters[indexCounter] = data
                        updatedContent = rollerShutters
                        // saving new sections data to userDefaults
                        if let rollerShuttersData = try? PropertyListEncoder().encode(rollerShutters) {
                            UserDefaults.standard.set(rollerShuttersData, forKey: "rollerShutters")
                        }
                        
                        let newSection = Section(title: section.title, content: updatedContent, isOpened: true)
                     
                        sections[sectionCounter] = newSection
                        // complete sections update
                        completion(sections)
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
                        // saving new sections data to userDefaults
                        if let heatersData = try? PropertyListEncoder().encode(heaters) {
                            UserDefaults.standard.set(heatersData, forKey: "heaters")
                        }
                        
                        let newSection = Section(title: section.title, content: updatedContent, isOpened: true)
                        
                        sections[sectionCounter] = newSection
                        // complete sections update
                        completion(sections)
                    }else {
                        sectionCounter += 1
                    }
                }
            case .failure(let error):
                print("occured error in getting sections from userDefaults:\(error)")
            }
        }
        
        
    }
    // MARK:  Retrieving old sections value from userDefaults in success case 
    func getSectionsFromUserDefault(completion:@escaping (Result<[Section],Error>)->()){
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
}
