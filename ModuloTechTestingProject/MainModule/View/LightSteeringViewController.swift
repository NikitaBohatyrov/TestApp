//
//  LightSteeringViewController.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 10.08.2022.
//

import UIKit

class LightSteeringViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    
    var viewModel:LightSteeringViewModel!
    
    private var mode:Bool!
    private var intensity:Int!
    
    private var DeviceLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Gray")
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let circle:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        view.layer.cornerRadius = 40
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.systemYellow.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let intensityLabel:UILabel = {
        let label = UILabel()
        label.text = "intensity: 0%"
        label.textColor = UIColor(named: "Gray")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
   private let rangeSlider = Slider(frame: .zero)
    
    init(with model:Any){
        super.init(nibName: nil, bundle: nil)
        if let model = model as? Light{
            DeviceLabel.text = model.name
            mode = model.mode
            intensity = model.intensity
            
            if model.mode && model.intensity > 0{
                
                rangeSlider.value = Float(intensity)/100
                circle.layer.shadowOpacity = rangeSlider.value*10
                circle.layer.shadowRadius = CGFloat(intensity/3)
                imageView.image = UIImage(named: "DeviceLightOnIcon")!
                intensityLabel.text = "on at \(intensity ?? 0)% "
                
            }else {
                imageView.image = UIImage(named: "DeviceLightOffIcon")!
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeSlider.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "DarkGray")
        title = DeviceLabel.text
        
        view.addSubview(imageView)
        view.addSubview(intensityLabel)
        view.addSubview(rangeSlider)
        view.addSubview(circle)
        view.sendSubviewToBack(circle)
        setUpNavBar()
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: -50),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            circle.centerYAnchor.constraint(equalTo: imageView.centerYAnchor,constant: -10),
            circle.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            circle.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5),
            circle.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5),
            intensityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            intensityLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: imageView.frame.size.height/4),
            intensityLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            intensityLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            rangeSlider.topAnchor.constraint(equalTo: intensityLabel.bottomAnchor, constant: imageView.frame.size.height/4),
            rangeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rangeSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            rangeSlider.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.05)
        ])
        rangeSlider.addTarget(self, action: #selector(updateIntanseLabel), for: .valueChanged)
        
       
    }
    private func setUpNavBar(){
        navigationController?.navigationBar.topItem?.title = ""
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor(named: "LightGray")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "LightGray")]
    }
    
    @objc private func updateIntanseLabel(){
        let valueToChange = Int(rangeSlider.value*100)
        let lampShadow = CGFloat(valueToChange/3)
        circle.layer.shadowRadius = lampShadow
        circle.layer.shadowOpacity = rangeSlider.value*10
        self.intensityLabel.text = "on at \(valueToChange)%"
    }
    
}
