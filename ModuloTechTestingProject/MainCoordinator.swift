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
            var vc:UIViewController & Coordinating
            if let viewModel = data as? LightCellViewModel{
                vc = LightSteeringViewController(with: viewModel)
                vc.title = viewModel.device.name
                vc.coordinator = self
            }else if let data = data as? RollerShutterCellViewModel{
                vc = RollerShutterSteeringViewController(with: data)
                vc.title = data.device.name
                vc.coordinator = self
            } else if let data = data as? HeaterCellViewModel{
                vc = HeaterSteeringViewController(with: data)
                vc.title = data.device.name
                vc.coordinator = self
            }else {
                return
            }
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            navigationController?.view.window!.layer.add(transition, forKey: kCATransition)
            navigationController?.pushViewController(vc, animated: false)
        case .backButtonTapped:
           return
        }
    }
    
    func backScroll() {
        var vc:UIViewController & Coordinating = MainViewController()
        vc.coordinator = self
        
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        navigationController?.view.window!.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(vc, animated: false)
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
