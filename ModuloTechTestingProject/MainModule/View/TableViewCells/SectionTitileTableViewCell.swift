//
//  SectionTitileTableViewCell.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 09.08.2022.
//

import UIKit

class SectionTitileTableViewCell: UITableViewCell {

    static let identifier = "SectionTitileTableViewCell"
    
    var title:UILabel = {
        let title = UILabel()
        title.text = "Section title"
        title.textColor = UIColor(named: "Black")
        title.translatesAutoresizingMaskIntoConstraints = false
        
        return title
    }()
    
    var icon:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.addSubview(title)
        contentView.addSubview(icon)
        NSLayoutConstraint.activate([
        title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 40),
        title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        title.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
        title.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
        icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
        icon.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10),
        icon.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
        icon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
        ])
    }
    
    func configure(with section:String){
        title.text = section
        switch section{
        case "Lights":
            icon.image = UIImage(named: "DeviceLightOnIcon")
        case "Heaters":
            icon.image = UIImage(named: "DeviceHeaterOnIcon")
        case "Roller shutters":
            icon.image = UIImage(named: "DeviceRollerShutterIcon")
        default:
            return
        }
    }
}
