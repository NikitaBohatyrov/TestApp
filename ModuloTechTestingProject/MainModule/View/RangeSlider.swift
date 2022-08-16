//
//  RangeSlider.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 10.08.2022.
//

import UIKit

class Slider: UISlider {
    
    private let baseLayer = CALayer()
    
    private let trackLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    private func setup(){
        clear()
        createBaseLayer()
        configureTrackLayer()
        createThumbImageView()
        valueChanged(self)
        
        addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    private func clear(){
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
        thumbTintColor = .clear
    }
    
    
    
    @objc func valueChanged(_ sender:Slider){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let thumbRectA = thumbRect(forBounds: bounds,
                                   trackRect: trackRect(forBounds: bounds),
                                   value: value)
        
        trackLayer.frame = .init(x: 0, y: frame.height/4, width: thumbRectA.midX, height: frame.height/2)
        
        CATransaction.commit()
    }
    
    private func createBaseLayer(){
        baseLayer.borderWidth = 2
        baseLayer.borderColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 1).cgColor
        baseLayer.masksToBounds = true
        baseLayer.backgroundColor = UIColor.clear.cgColor
        baseLayer.frame = .init(x: 0, y: frame.height/4, width: frame.width, height: frame.height/2)
        baseLayer.cornerRadius = baseLayer.frame.height/2
        layer.insertSublayer(baseLayer, at: 0)
    }
    
    private func createThumbImageView(){
        let thumgSize = (3*frame.height) / 2
        let thumbView = Thumb(frame: .init(x: 0, y: 0, width: thumgSize, height: thumgSize))
        
        thumbView.layer.cornerRadius = thumgSize/2
        let thumbSnapshot = thumbView.snapshot
        setThumbImage(thumbSnapshot, for: .normal)
        setThumbImage(thumbSnapshot, for: .normal)
        setThumbImage(thumbSnapshot, for: .highlighted)
        setThumbImage(thumbSnapshot, for: .application)
        setThumbImage(thumbSnapshot, for: .focused)
        setThumbImage(thumbSnapshot, for: .reserved)
        setThumbImage(thumbSnapshot, for: .selected)
    }
    
    private func configureTrackLayer(){
        let firstColor = UIColor(named: "Gray")!.cgColor
        let secondColor = UIColor.systemYellow.cgColor
        trackLayer.colors = [firstColor,secondColor]
        trackLayer.startPoint = .init(x: 0.25, y: 0.5)
        trackLayer.endPoint = .init(x: 1.25, y: 0.5)
        trackLayer.frame = .init(x: 10, y: frame.height/4, width: 0, height: frame.height/2)
        trackLayer.cornerRadius = trackLayer.frame.height/2
        layer.insertSublayer(trackLayer, at: 1)
    }
}

final class Thumb:UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.systemYellow
    }
}



