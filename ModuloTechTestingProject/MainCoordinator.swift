//
//  MainCoordinator.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 10.08.2022.
//

import Foundation
import UIKit

class MainCoordinator:Coordinator{
    
    var navigationController: UINavigationController?
    
    func eventOccured(with type: Event,data:Any) {
        switch type {
        case .cellTapped:
            var vc:UIViewController & Coordinating = LightSteeringViewController(with: data)
            vc.coordinator = self
            navigationController?.isNavigationBarHidden = false
            navigationController?.show(vc, sender: self)
        case .popedVC:
            var vc:UIViewController & Coordinating = MainViewController()
            vc.coordinator = self
            navigationController?.isNavigationBarHidden = true
        }
    }
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        var vc:UIViewController & Coordinating = MainViewController()
        vc.coordinator = self
        
        navigationController?.setViewControllers([vc],
                                                animated: false)
    }
    
    
}
