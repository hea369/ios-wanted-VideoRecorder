//
//  FirstPageTableViewCell.swift
//  VideoRecorder
//
//  Created by 박호현 on 2022/10/11.
//

import UIKit

class FirstPageTableViewCell: UITableViewCell {
    
    static let identifier = "FirstPageTableViewCell"
    
    let textlabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: CGFloat(20))
        return label
    }()
    
    let datelabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: CGFloat(14))
        return label
    }()
    
    let viewUI: UIView = {
        let viewui = UIView()
        viewui.backgroundColor = .black
        viewui.translatesAutoresizingMaskIntoConstraints = false
        viewui.layer.cornerRadius = 20
        return viewui
    }()
    
    let image: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .white
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 20
        imageview.clipsToBounds = true
        return imageview
    }()
    
    let timelabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    
    let viewUI2: UIView = {
        let viewui2 = UIView()
        viewui2.translatesAutoresizingMaskIntoConstraints = false
        viewui2.layer.cornerRadius = 5
        return viewui2
    }()
    
    let image2: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 5
        imageview.tintColor = .label
        return imageview
    }()
    
    let image3: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 5
        imageview.tintColor = .label
        return imageview
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        settingView()
        cellUILayout()
        
    }
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func cellUILayout() {
        
        NSLayoutConstraint.activate([
            
            viewUI.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            viewUI.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            viewUI.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            viewUI.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            viewUI.heightAnchor.constraint(equalToConstant: 80),
            viewUI.widthAnchor.constraint(equalToConstant: 80),
            
            image.topAnchor.constraint(equalTo: viewUI.topAnchor, constant: 2),
            image.leadingAnchor.constraint(equalTo: viewUI.leadingAnchor, constant: 2),
            image.trailingAnchor.constraint(equalTo: viewUI.trailingAnchor, constant: -2),
            image.bottomAnchor.constraint(equalTo: viewUI.bottomAnchor, constant: -2),
            
            timelabel.topAnchor.constraint(equalTo: image.topAnchor, constant: 55),
            timelabel.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 5),
            timelabel.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -5),
            timelabel.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -5),
            
            textlabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            textlabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            textlabel.widthAnchor.constraint(equalToConstant: 160),
            
            datelabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            datelabel.topAnchor.constraint(equalTo: textlabel.bottomAnchor, constant: 10),
            
            viewUI2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            viewUI2.centerYAnchor.constraint(equalTo: viewUI.centerYAnchor),
            viewUI2.widthAnchor.constraint(equalToConstant: 80),
            viewUI2.heightAnchor.constraint(equalToConstant: 40),
            
            image2.topAnchor.constraint(equalTo: viewUI2.topAnchor, constant: 17),
            image2.leadingAnchor.constraint(equalTo: viewUI2.leadingAnchor, constant: 2),
            image2.bottomAnchor.constraint(equalTo: viewUI2.bottomAnchor, constant: -17),
            image2.widthAnchor.constraint(equalToConstant: 35),
            
            image3.topAnchor.constraint(equalTo: viewUI2.topAnchor, constant: 5),
            image3.leadingAnchor.constraint(equalTo: image2.trailingAnchor, constant: 5),
            image3.bottomAnchor.constraint(equalTo: viewUI2.bottomAnchor, constant: -5),
            image3.widthAnchor.constraint(equalToConstant: 35)
            
        ])
    }
    
    func settingView() {
        self.addSubview(viewUI)
        self.addSubview(textlabel)
        self.addSubview(image)
        self.addSubview(datelabel)
        self.addSubview(viewUI2)
        self.addSubview(image2)
        self.addSubview(image3)
        self.addSubview(timelabel)
    }
    
}
