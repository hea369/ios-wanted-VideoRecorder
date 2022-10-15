//
//  HeaderView.swift
//  VideoRecorder
//
//  Created by 박호현 on 2022/10/12.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "HeaderView"
    
    let textlabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let videoButton: UIButton = {
        let videobutton = UIButton()
        videobutton.setImage(UIImage(systemName: "video.fill.badge.plus"), for: .normal)
        videobutton.translatesAutoresizingMaskIntoConstraints = false
        videobutton.tintColor = .label
        return videobutton
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setting()
        headerUILayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func headerUILayout() {
        
        NSLayoutConstraint.activate([
          
            textlabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textlabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            textlabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            videoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            videoButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            videoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    func setting() {
        addSubview(textlabel)
        addSubview(videoButton)
    }
}
