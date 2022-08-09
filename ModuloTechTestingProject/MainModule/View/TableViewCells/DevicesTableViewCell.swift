//
//  LightDeviceTableViewCell.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 09.08.2022.
//

import UIKit

class DevicesTableViewCell: UITableViewCell {
    
    static let identifier = "DevicesTableViewCell"
    
    private var deviceName:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
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
    
    private var stateLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
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
            deviceName.centerYAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            deviceName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            deviceName.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            stateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            stateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10),
            stateLabel.widthAnchor.constraint(equalTo: deviceName.widthAnchor),
            stateLabel.heightAnchor.constraint(equalTo: deviceName.heightAnchor, multiplier: 0.6),
            stateIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stateIcon.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10),
            stateIcon.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            stateIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
        ])

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with model:Any){
            if let model = model as? Light {
                deviceName.text = model.name
               
                if model.mode && model.intensity > 0{
                    stateLabel.text = "on with \(model.intensity)% of power"
                    stateIcon.image = UIImage(named: "DeviceLightOnIcon")!
                }else {
                    stateLabel.text = "Off"
                    stateIcon.image = UIImage(named: "DeviceLightOffIcon")!
                }
                
            }else if let model = model as? Heater{
                deviceName.text = model.name
                
                if model.mode{
                    stateLabel.text = "on at \(model.temperature)℃"
                    stateIcon.image = UIImage(named: "DeviceHeaterOnIcon")!
                }else {
                    stateLabel.text = "Off"
                    stateIcon.image = UIImage(named: "DeviceHeaterOffIcon")!
                }
                
            }else if let model = model as? RollerShutter{
                deviceName.text = model.name
                
                switch model.position {
                case 0:
                    stateLabel.text = "opened"
                    stateIcon.image = UIImage(named: "DeviceRollerShutterOpenedIcon")!
                case 100:
                    stateLabel.text = "closed"
                    stateIcon.image = UIImage(named: "DeviceRollerShutterClosedIcon")!
                default:
                    stateLabel.text = "opened on \(model.position)%"
                    stateIcon.image = UIImage(named: "DeviceRollerShutterIcon")!
                }
            }
        }
}
