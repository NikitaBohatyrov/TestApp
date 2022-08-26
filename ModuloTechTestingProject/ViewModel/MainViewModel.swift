//
//  MainViewModel.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 05.08.2022.
//

import Foundation

final class MainViewModel{
    
    var reloadTableView:(()->Void)?
    
    var sections = [Section](){
        didSet{
            reloadTableView?()
        }
    }
    
    var lightViewModels = [LightCellViewModel](){
        didSet{
            reloadTableView?()
        }
    }
    var rollerShutterViewModels = [RollerShutterCellViewModel](){
        didSet{
            reloadTableView?()
        }
    }
    var heaterViewModels = [HeaterCellViewModel](){
        didSet{
            reloadTableView?()
        }
    }
    
    public func loadView(){
        Parser.parse {[weak self] parsedResult in
            DeviceManager().getDevices(devices: parsedResult) { [weak self] sortedDevices in
                self?.sections = sortedDevices
                self?.fetchDevices(sections: sortedDevices)
            }
        }
    }
    
    public func fetchDevices(sections:[Section]){
        var tmpLight = [LightCellViewModel]()
        var tmpHeater = [HeaterCellViewModel]()
        var tmpRollerShutter = [RollerShutterCellViewModel]()
        for section in sections {
            for content in section.content{
                if let data = content as? Light{
                    tmpLight.append(LightCellViewModel(device: data))
                }else if let data = content as? Heater{
                    tmpHeater.append(HeaterCellViewModel(device: data))
                }else if let data = content as? RollerShutter{
                    tmpRollerShutter.append(RollerShutterCellViewModel(device: data))
                }
            }
        }
        lightViewModels = tmpLight
        rollerShutterViewModels = tmpRollerShutter
        heaterViewModels = tmpHeater
    }
    
    func getLightCellViewModel(at indexPath:IndexPath)->LightCellViewModel{
        return lightViewModels[indexPath.row-1]
    }
    
    func getRollerShutterCellViewModel(at indexPath:IndexPath)->RollerShutterCellViewModel{
        return rollerShutterViewModels[indexPath.row-1]
    }
    
    func getHeaterCellViewModel(at indexPath:IndexPath)->HeaterCellViewModel{
        return heaterViewModels[indexPath.row-1]
    }
    
    // MARK: Updates Sections with given updated data and saves it to userDefaults, and throws updated Sections
    public func updateSection(updatedData:Any,completion:@escaping ([Section])->()){
       
        UserDefaultsManager.get { result in
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
}
