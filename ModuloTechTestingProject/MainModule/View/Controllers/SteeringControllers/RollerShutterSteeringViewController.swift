//
//  RollerShutterSteeringViewController.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 14.08.2022.
//

import UIKit

class RollerShutterSteeringViewController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    var viewModel:RollerShutterCellViewModel?
    
    private var device:RollerShutter!
    private var position:Int!
    
    private var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let controlPanelView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 70/255, green: 100/255, blue: 140/255, alpha: 1)
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let positionLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "LightGray")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private let rangeSlider:UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        slider.minimumTrackTintColor = UIColor(red: 19/255, green: 108/255, blue: 164/255, alpha: 1)
        slider.maximumTrackTintColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 1)
        slider.thumbTintColor = UIColor(red: 19/255, green: 108/255, blue: 164/255, alpha: 1)
        return slider
    }()
    
    init(with model:RollerShutterCellViewModel){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = model
        self.device = model.device
        self.position = model.device.position
        rangeSlider.value = Float(model.device.position)/100
        model.updatePositionUI(rangeSlider.value, completion: {[weak self] updatedPosition, shutterImage, positionStr, _ in
            self?.imageView.image = shutterImage
            if positionStr != ""{
                self?.positionLabel.text = positionStr
            }else {
                self?.positionLabel.text = "\(updatedPosition)%"
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.updatePositionUI(rangeSlider.value, completion: {[weak self] updatedPosition, shutterImage, positionStr, backgroungColor in
            self?.view.backgroundColor = backgroungColor
        })
       
        setUpView()
        setUpNavBar()
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: -100),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            positionLabel.centerXAnchor.constraint(equalTo: controlPanelView.centerXAnchor),
            positionLabel.topAnchor.constraint(equalToSystemSpacingBelow: controlPanelView.topAnchor, multiplier: 1),
            positionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            positionLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            rangeSlider.topAnchor.constraint(equalToSystemSpacingBelow: positionLabel.bottomAnchor, multiplier:8),
            rangeSlider.centerXAnchor.constraint(equalTo: controlPanelView.centerXAnchor),
            rangeSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            rangeSlider.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.05),
            controlPanelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlPanelView.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 40),
            controlPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 20),
            controlPanelView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        rangeSlider.addTarget(self, action: #selector(updatePositionLabel), for: .valueChanged)
        
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didTapDone))
        swipeGestureRecognizerLeft.direction = .right
        view.addGestureRecognizer(swipeGestureRecognizerLeft)
        
    }
    
    private func setUpView(){
        controlPanelView.addSubview(positionLabel)
        controlPanelView.addSubview(rangeSlider)
        view.addSubview(controlPanelView)
        view.addSubview(imageView)
    }
    
    private func setUpNavBar(){
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor(named: "LightGray")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "LightGray")!]
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.title = device.name.localized()
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc func didTapDone(){
        viewModel?.saveAndSendRollerShutterObject(updatedValue: position) {[weak self] device in
            UserDefaultsManager.manageRollerShutters(device: device)
            self?.coordinator?.backScroll()
        }
    }
    
    @objc private func updatePositionLabel(){
        viewModel?.updatePositionUI(rangeSlider.value, completion: {[weak self] updatedPosition, shutterImage, positionStr, backgroungColor in
            self?.position = updatedPosition
            self?.imageView.image = shutterImage
            if positionStr != ""{
                self?.positionLabel.text = positionStr
            }else {
                self?.positionLabel.text = "\(updatedPosition)%"
            }
           
            self?.view.backgroundColor = backgroungColor
        })
    }
    
   
}
