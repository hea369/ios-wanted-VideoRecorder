//
//  ControlView.swift
//  VideoRecorder
//
//  Created by 엄철찬 on 2022/10/12.
//

import UIKit

protocol ControlViewDelegate{
    func switchCamera()
    func rollCamera()
}

class ControlView : UIView {
    
    var delegate : ControlViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        blurEffect()
        setRecordButton()
        setswitchButton()
        setTimeLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func blurEffect(){
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.addSubview(visualEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.widthAnchor.constraint(equalTo: self.widthAnchor),
            visualEffectView.heightAnchor.constraint(equalTo: self.heightAnchor),
            visualEffectView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            visualEffectView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setRecordButton(){
        self.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordButton.widthAnchor.constraint(equalToConstant: 70),
            recordButton.heightAnchor.constraint(equalToConstant: 70),
            recordButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            recordButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setTimeLabel(){
        self.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.widthAnchor.constraint(equalToConstant: 60),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).withMultiplier(0.4)
        ])
    }
    
    func setswitchButton(){
        self.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            switchButton.widthAnchor.constraint(equalToConstant: 40),
            switchButton.heightAnchor.constraint(equalToConstant: 40),
            switchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            switchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).withMultiplier(1.6)
        ])
    }
    
    lazy var recordButton : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 35
        btn.addTarget(self, action: #selector(rollCamera), for: .touchUpInside)
        return btn
    }()
    let timeLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        lbl.textAlignment = .left
        lbl.text = "00:00"
        return lbl
    }()
    lazy var switchButton : UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        let img = UIImage(systemName: "camera.rotate",withConfiguration: config)
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func switchButtonAction(){
        delegate?.switchCamera()
    }
    
    @objc func rollCamera(){
        delegate?.rollCamera()
    }
}
