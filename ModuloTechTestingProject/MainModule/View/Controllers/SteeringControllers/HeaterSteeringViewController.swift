//
//  HeaterSteeringViewController.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 14.08.2022.
//

import UIKit

class HeaterSteeringViewController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    var viewModel = SteeringViewModel()
    
    private var device:Heater!
    private var mode:Bool!
    private var temperature:Double!
    private var timer: Timer?
    
    private var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let shadowElipse:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let controlPanelView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 70/255, green: 100/255, blue: 140/255, alpha: 1)
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 19/255, green: 108/255, blue: 164/255, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let minusButton:UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.6)
        button.setTitle("-0.5℃", for: .normal)
        button.setTitleColor(UIColor(named: "LightGray"), for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.layer.borderColor =  UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.3).cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private let plusButton:UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.6)
        button.setTitle("+0.5℃", for: .normal)
        button.setTitleColor(UIColor(named: "LightGray"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderColor =  UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.3).cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let temperatureLabel:UILabel = {
        let label = UILabel()
        label.text = "0℃"
        label.textColor = UIColor(named: "LightGray")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private let powerButton:UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 1)
        button.setTitleColor(UIColor(named: "LightGray"), for: .normal)
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(red: 36/255, green: 36/255, blue: 70/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(with model:Heater){
        super.init(nibName: nil, bundle: nil)
        device = model
        mode = model.mode
        temperature = model.temperature
        
        if model.mode {
            powerButton.setTitle("Off".localized(), for: .normal)
            shadowElipse.backgroundColor = UIColor.systemYellow
            controlShadow(appear: true)
            imageView.image = UIImage(named: "DeviceHeaterOnIcon")!
            temperatureLabel.text = "\(temperature ?? 0)℃"
            
        }else {
            powerButton.setTitle("On".localized(), for: .normal)
            plusButton.isEnabled = false
            plusButton.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.3)
            minusButton.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.3)
            minusButton.isEnabled = false
            shadowElipse.backgroundColor = UIColor(named: "LightGray")
            imageView.image = UIImage(named: "DeviceHeaterOffIcon")!
            temperatureLabel.text = "\(temperature ?? 0)℃"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 1)
        
        controlPanelView.addSubview(temperatureLabel)
        controlPanelView.addSubview(powerButton)
        controlPanelView.addSubview(minusButton)
        controlPanelView.addSubview(plusButton)
        view.addSubview(shadowElipse)
        view.sendSubviewToBack(shadowElipse)
        view.addSubview(controlPanelView)
        view.addSubview(imageView)
        
        setUpNavBar()
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: -100),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            shadowElipse.topAnchor.constraint(equalTo: imageView.topAnchor,constant: 10 ),
            shadowElipse.centerXAnchor.constraint(equalTo: imageView.centerXAnchor,constant: -16),
            shadowElipse.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.17),
            shadowElipse.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.8),
            temperatureLabel.centerXAnchor.constraint(equalTo: controlPanelView.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalToSystemSpacingBelow: controlPanelView.topAnchor, multiplier: 2),
            temperatureLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            temperatureLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            plusButton.topAnchor.constraint(equalToSystemSpacingBelow: temperatureLabel.bottomAnchor, multiplier:3),
            plusButton.leftAnchor.constraint(equalTo: controlPanelView.centerXAnchor,constant: 20),
            plusButton.widthAnchor.constraint(equalTo:    controlPanelView.widthAnchor, multiplier: 0.35),
            plusButton.heightAnchor.constraint(equalTo: minusButton.widthAnchor, multiplier: 0.4),
            minusButton.topAnchor.constraint(equalToSystemSpacingBelow: temperatureLabel.bottomAnchor, multiplier:3),
            minusButton.rightAnchor.constraint(equalTo: controlPanelView.centerXAnchor,constant: -20),
            minusButton.widthAnchor.constraint(equalTo:    controlPanelView.widthAnchor, multiplier: 0.35),
            minusButton.heightAnchor.constraint(equalTo: minusButton.widthAnchor, multiplier: 0.4),
            powerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            powerButton.topAnchor.constraint(equalToSystemSpacingBelow: minusButton.bottomAnchor, multiplier: 5),
            powerButton.widthAnchor.constraint(equalTo: controlPanelView.widthAnchor, multiplier: 0.35),
            powerButton.heightAnchor.constraint(equalTo: powerButton.widthAnchor, multiplier: 0.4),
            controlPanelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlPanelView.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 40),
            controlPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 20),
            controlPanelView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        powerButton.addTarget(self, action: #selector(switchMode), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        plusButton.addTarget(self, action: #selector(buttonUp(_:)), for: [.touchUpInside,.touchUpOutside])
        minusButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        minusButton.addTarget(self, action: #selector(buttonUp(_:)), for: [.touchUpInside,.touchUpOutside])
        
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didTapDone))
        swipeGestureRecognizerLeft.direction = .right
        view.addGestureRecognizer(swipeGestureRecognizerLeft)
    }
    
    private func setUpNavBar(){
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor(named: "LightGray")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "LightGray")!]
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.title = device.name.localized()
    }
    
    @objc func buttonDown(_ sender:UIButton){
        if sender == plusButton{
            minusButton.isEnabled = false
            sender.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.3)
            increaseTemperature()
            timer = Timer.scheduledTimer(timeInterval: 0.2,
                                         target: self,
                                         selector: #selector(increaseTemperature),
                                         userInfo: nil, repeats: true)
        }else {
            plusButton.isEnabled = false
            sender.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.3)
            
            decreaseTemperature()
            timer = Timer.scheduledTimer(timeInterval: 0.2,
                                         target: self,
                                         selector: #selector(decreaseTemperature),
                                         userInfo: nil, repeats: true)
        }
    }
    
    @objc func buttonUp(_ sender:UIButton){
        if sender == plusButton {
            minusButton.isEnabled = true
        }else {
            plusButton.isEnabled = true
        }
        sender.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.6)
        
        timer?.invalidate()
        controlShadow(appear: false)
    }
    
    @objc func increaseTemperature(){
        if temperature < 28 {
            temperature += 0.5
            temperatureLabel.text = "\(temperature ?? 0.0)℃"
            shadowElipse.layer.shadowColor = UIColor.systemRed.cgColor
            controlShadow(appear: true)
        }
    }
    
    @objc func decreaseTemperature(){
        if temperature > 7.0 {
            temperature -= 0.5
            temperatureLabel.text = "\(temperature ?? 0.0)℃"
            shadowElipse.layer.shadowColor = UIColor.link.cgColor
            controlShadow(appear: true)
        }
    }
    
    @objc func didTapDone(){
        viewModel.saveAndSendHeaterObject(model: device!, updatedMode: mode, updatedValue: temperature) {[weak self] updatedHeater in
            self?.coordinator?.eventOccured(with: .backButtonTapped, data: updatedHeater)
        }
    }
    
    @objc func switchMode(){
        if mode {
            powerButton.setTitle("On".localized(), for: .normal)
            mode = !mode
            minusButton.isEnabled = false
            minusButton.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.3)
            plusButton.isEnabled = false
            plusButton.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.3)
            shadowElipse.backgroundColor = UIColor(named: "Gray")
            imageView.image = UIImage(named: "DeviceHeaterOffIcon")!
        }else{
            powerButton.setTitle("Off".localized(), for: .normal)
            mode = !mode
            minusButton.isEnabled = true
            minusButton.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.6)
            plusButton.isEnabled = true
            plusButton.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 0.6)
            shadowElipse.backgroundColor = UIColor.systemYellow
            imageView.image = UIImage(named: "DeviceHeaterOnIcon")!
        }
    }
    
    func controlShadow(appear:Bool){
        if appear{
            shadowElipse.layer.shadowRadius = 40
            shadowElipse.layer.shadowOpacity = 1
            shadowElipse.layer.shadowOffset = .zero
            shadowElipse.layer.shouldRasterize = true
            shadowElipse.layer.rasterizationScale = UIScreen.main.scale
        }else{
            shadowElipse.layer.shadowRadius = 0
            shadowElipse.layer.shadowColor = UIColor.clear.cgColor
            shadowElipse.layer.shadowOpacity = 0
            
        }
        
    }
}
