//
//  Coordinator.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 10.08.2022.
//

import Foundation
import UIKit

enum Event {
    case cellTapped,backButtonTapped
}

protocol Coordinator{
    var navigationController: UINavigationController? {get set}
    
    func eventOccured(with type: Event,data:Any)
    func backScroll()
    func start()
}

protocol Coordinating {
    var coordinator:Coordinator? {get set}
}
