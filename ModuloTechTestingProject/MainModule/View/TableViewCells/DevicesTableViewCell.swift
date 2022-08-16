//
//  LightDeviceTableViewCell.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 09.08.2022.
//

import UIKit

class DevicesTableViewCell: UITableViewCell {
    
    static let identifier = "DevicesTableViewCell"
    
    var deviceName:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "LightGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var stateIcon:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var stateLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "LightGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.addSubview(deviceName)
        contentView.addSubview(stateIcon)
        contentView.addSubview(stateLabel)
        
        NSLayoutConstraint.activate([
            deviceName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            deviceName.bottomAnchor.constraint(equalTo: contentView.centerYAnchor,constant: -5),
            deviceName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            deviceName.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            stateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            stateLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 5),
            stateLabel.widthAnchor.constraint(equalTo: deviceName.widthAnchor),
            stateLabel.heightAnchor.constraint(equalTo: deviceName.heightAnchor, multiplier: 0.6),
            stateIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stateIcon.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10),
            stateIcon.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            stateIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
        ])
        
    }
    
    func configure(with model:Any){
        if let model = model as? Light {
            deviceName.text = model.name.localized()
            
            if model.mode{
                stateLabel.text = "Turned on with %lld%% of power".localizedWithParameters(model.intensity)
                stateIcon.image = UIImage(named: "DeviceLightOnIcon")!
            }else {
                stateLabel.text = "Off".localized()
                stateIcon.image = UIImage(named: "DeviceLightOffIcon")!
            }
            
        }else if let model = model as? Heater{
            deviceName.text = model.name.localized()
            
            if model.mode{
                stateLabel.text = "Turned on at %.1f%℃".localizedWithParameters(model.temperature)
                stateIcon.image = UIImage(named: "DeviceHeaterOnIcon")!
            }else {
                stateLabel.text = "Off".localized()
                stateIcon.image = UIImage(named: "DeviceHeaterOffIcon")!
            }
            
        }else if let model = model as? RollerShutter{
            deviceName.text = model.name.localized()
            
            switch model.position {
            case 0:
                stateLabel.text = "Opened".localized()
                stateIcon.image = UIImage(named: "DeviceRollerShutterOpenedIcon")!
            case 100:
                stateLabel.text = "Closed".localized()
                stateIcon.image = UIImage(named: "DeviceRollerShutterClosedIcon")!
            default:
                stateLabel.text = "Opened on %lld%%".localizedWithParameters(model.position)
                stateIcon.image = UIImage(named: "DeviceRollerShutterIcon")!
            }
        }
    }
}
