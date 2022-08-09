//
//  LightDeviceTableViewCell.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 09.08.2022.
//

import UIKit

class LightDeviceTableViewCell: UITableViewCell {
    
    static let identifier = "LightDeviceTableViewCell"
    
    private var title:UILabel = {
        let label = UILabel()
        label.text = "section title"
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with:[Light]){
        
    }

}
