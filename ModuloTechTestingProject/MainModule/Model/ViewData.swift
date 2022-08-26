//
//  ViewData.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 05.08.2022.
//

import Foundation


struct Root: Codable {
    let devices: [Device]
    let user: User
}


struct Device: Codable {
    let id: Int
    let deviceName: String
    let intensity: Int?
    let mode: String?
    let productType: ProductType
    let position: Int?
    let temperature: Double?
}

enum ProductType: String, Codable {
    case heater = "Heater"
    case light = "Light"
    case rollerShutter = "RollerShutter"
    
}


struct User: Codable {
    let firstName, lastName: String
    let address: Address
    let birthDate: Int
}


struct Address: Codable {
    let city: String
    let postalCode: Int
    let street, streetCode, country: String
}

class Light:Codable{
    var id: Int
    var name: String
    var intensity: Int 
    var mode: Bool!
    
    init(id:Int,name:String,intensity:Int,mode:String){
        self.id = id
        self.name = name
        self.intensity = intensity
        if mode == "ON"{
            self.mode = true
        }
        else if mode == "OFF"{
            self.mode = false
        }
    }
}

class Heater:Codable{
    var id: Int
    var name: String
    var temperature: Double
    var mode: Bool!
    
    init(id:Int,name:String,temp:Double,mode:String){
        self.id = id
        self.name = name
        self.temperature = temp
        if mode == "ON"{
            self.mode = true
        }
        else if mode == "OFF"{
            self.mode = false
        }
    }
}

class RollerShutter:Codable{
    var id: Int
    var name: String
    var position: Int
    
    init(id:Int,name:String,position:Int){
        self.id = id
        self.name = name
        self.position = position
    }
}

struct Section{
    let title:String
    var content:[Any]
    var isOpened:Bool
    
}



enum DefineClass:Codable {
    case heater(Heater)
    case light(Light)
    case rollerShutter(RollerShutter)
}

