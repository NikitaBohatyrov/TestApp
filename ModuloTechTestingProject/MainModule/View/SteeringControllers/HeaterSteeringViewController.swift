//
//  HeaterSteeringViewController.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 14.08.2022.
//

import UIKit

class HeaterSteeringViewController: UIViewController,Coordinating {
    
    var coordinator: Coordinator?
    
    var viewModel = SteeringViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
}