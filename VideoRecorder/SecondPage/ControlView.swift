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
        setRedButton()
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
    
    func setRedButton(){
        recordButton.addSubview(redButton)
        redButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            redButton.widthAnchor.constraint(equalToConstant: 50),
            redButton.heightAnchor.constraint(equalToConstant: 50),
            redButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            redButton.centerXAnchor.constraint(equalTo: recordButton.centerXAnchor)
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
    lazy var redButton : RedButton = {
        let btn = RedButton()
        btn.backgroundColor = .red
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 25
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
    
    func redButtonRecordingAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10){
            self.redButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.redButton.layer.cornerRadius = 5
        }
    }
    
    func redButtonStopAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10){
            self.redButton.transform = .identity
            self.redButton.layer.cornerRadius = 25
        }
    }
}

class RedButton : UIView{
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if self == hitView{
            return nil
        }
        return hitView
    }
}
