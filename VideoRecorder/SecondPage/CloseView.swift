//
//  CloseView.swift
//  VideoRecorder
//
//  Created by 엄철찬 on 2022/10/12.
//

import UIKit

class CloseView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        blurEffect()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func blurEffect(){
        // 1
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let outerVisualEffectView = UIVisualEffectView(effect: blurEffect)
        self.addSubview(outerVisualEffectView)
        outerVisualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            outerVisualEffectView.widthAnchor.constraint(equalTo: self.widthAnchor),
            outerVisualEffectView.heightAnchor.constraint(equalTo: self.heightAnchor),
            outerVisualEffectView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            outerVisualEffectView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        // 2
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let innerVisualEffectView = UIVisualEffectView(effect: vibrancyEffect)
        // 3
        outerVisualEffectView.contentView.addSubview(innerVisualEffectView)
        innerVisualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            innerVisualEffectView.widthAnchor.constraint(equalTo: outerVisualEffectView.widthAnchor),
            innerVisualEffectView.heightAnchor.constraint(equalTo: outerVisualEffectView.heightAnchor),
            innerVisualEffectView.centerYAnchor.constraint(equalTo: outerVisualEffectView.centerYAnchor),
            innerVisualEffectView.centerXAnchor.constraint(equalTo: outerVisualEffectView.centerXAnchor)
        ])
        // 4
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        let img = UIImage(systemName: "xmark.circle.fill",withConfiguration: config)
        let imgView = UIImageView(image: img)
        innerVisualEffectView.contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalTo: innerVisualEffectView.widthAnchor),
            imgView.heightAnchor.constraint(equalTo: innerVisualEffectView.heightAnchor),
            imgView.centerYAnchor.constraint(equalTo: innerVisualEffectView.centerYAnchor),
            imgView.centerXAnchor.constraint(equalTo: innerVisualEffectView.centerXAnchor)
        ])
    }
}
