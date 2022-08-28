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
        UserDefaultsManager.get { result in
            switch result{
            case .success(let fetchedSections):
                self.sections = fetchedSections
                self.fetchDevices(sections: fetchedSections)
            case .failure(let error):
                print("feiled to get sections from UserDefaults\(error)")
                
                Parser.parse {[weak self] parsedResult in
                    DeviceManager().getDevices(devices: parsedResult) { [weak self] sortedDevices in
                        self?.sections = sortedDevices
                        self?.fetchDevices(sections: sortedDevices)
                    }
                }
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
}
