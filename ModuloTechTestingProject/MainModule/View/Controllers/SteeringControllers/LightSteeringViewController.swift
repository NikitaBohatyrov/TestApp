//
//  LightSteeringViewController.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 10.08.2022.
//

import UIKit

class LightSteeringViewController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    var viewModel = SteeringViewModel()
    
    private var device:Light!
    private var mode:Bool!
    private var intensity:Int!
    
    private var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let circle:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 60
        view.layer.shadowColor = UIColor.systemYellow.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
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
    
    
    private let intensityLabel:UILabel = {
        let label = UILabel()
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
        button.layer.borderColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
   private let rangeSlider = Slider(frame: .zero)
    
    init(with model:Light){
        super.init(nibName: nil, bundle: nil)
            device = model
            mode = model.mode
            intensity = model.intensity
            
            if model.mode{
                powerButton.setTitle("Off".localized(), for: .normal)
                circle.backgroundColor = UIColor.systemYellow
                rangeSlider.value = Float(intensity)/100
                controlShadow(valueToChange: intensity)
                imageView.image = UIImage(named: "DeviceLightOnIcon")!
                intensityLabel.text = "\(intensity ?? 0)"
                
            }else {
                powerButton.setTitle("On".localized(), for: .normal)
                circle.backgroundColor = UIColor(named: "LightGray")
                imageView.image = UIImage(named: "DeviceLightOffIcon")!
                rangeSlider.value = Float(intensity)/100
                intensityLabel.text = "\(intensity ?? 0)"
                rangeSlider.isEnabled = false
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 1)
        
        controlPanelView.addSubview(intensityLabel)
        controlPanelView.addSubview(rangeSlider)
        controlPanelView.addSubview(powerButton)
        view.addSubview(circle)
        view.sendSubviewToBack(circle)
        view.addSubview(controlPanelView)
        view.addSubview(imageView)
        
        setUpNavBar()
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: -100),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            circle.bottomAnchor.constraint(equalTo: imageView.centerYAnchor,constant: 46 ),
            circle.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            circle.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5),
            circle.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5),
            intensityLabel.centerXAnchor.constraint(equalTo: controlPanelView.centerXAnchor),
            intensityLabel.topAnchor.constraint(equalToSystemSpacingBelow: controlPanelView.topAnchor, multiplier: 2),
            intensityLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            intensityLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            rangeSlider.topAnchor.constraint(equalToSystemSpacingBelow: intensityLabel.bottomAnchor, multiplier:2.5),
            rangeSlider.centerXAnchor.constraint(equalTo: controlPanelView.centerXAnchor),
            rangeSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            rangeSlider.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.05),
            powerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            powerButton.topAnchor.constraint(equalToSystemSpacingBelow: rangeSlider.bottomAnchor, multiplier: 6),
            powerButton.widthAnchor.constraint(equalTo: controlPanelView.widthAnchor, multiplier: 0.3),
            powerButton.heightAnchor.constraint(equalTo: powerButton.widthAnchor, multiplier: 0.4),
            controlPanelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlPanelView.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 40),
            controlPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 20),
            controlPanelView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        rangeSlider.translatesAutoresizingMaskIntoConstraints = false
        rangeSlider.addTarget(self, action: #selector(updateIntanseLabel), for: .valueChanged)
        
        powerButton.addTarget(self, action: #selector(switchMode), for: .touchUpInside)
        
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
    
    @objc func didTapDone(){
        viewModel.saveAndSendLightObject(model: device!, updatedMode: mode, updatedValue: intensity) {[weak self] updatedLight in
            self?.coordinator?.eventOccured(with: .backButtonTapped, data: updatedLight)
        }
    }
    
    @objc func switchMode(){
        if mode {
            powerButton.setTitle("On".localized(), for: .normal)
            mode = !mode
            controlShadow(valueToChange: 0)
            rangeSlider.isEnabled = false
            circle.backgroundColor = UIColor(named: "Gray")
            imageView.image = UIImage(named: "DeviceLightOffIcon")!
        }else{
            powerButton.setTitle("Off".localized(), for: .normal)
            mode = !mode
            rangeSlider.isEnabled = true
            updateIntanseLabel()
            circle.backgroundColor = UIColor.systemYellow
            imageView.image = UIImage(named: "DeviceLightOnIcon")!
        }
    }
    
    @objc private func updateIntanseLabel(){
        let valueToChange = Int(rangeSlider.value*100)
        self.intensity = valueToChange
        controlShadow(valueToChange: valueToChange)
        self.intensityLabel.text = "\(valueToChange)"
    }
    
    func controlShadow(valueToChange:Int){
        let lampShadow = CGFloat(valueToChange/3)
        circle.layer.shadowRadius = lampShadow
        circle.layer.shadowOpacity = rangeSlider.value*10
    }
}
