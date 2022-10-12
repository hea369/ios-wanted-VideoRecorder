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
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: CGFloat(20))
        return label
    }()
    
    let datelabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
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
        imageview.image = UIImage(named: "")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 20
        return imageview
    }()
    
    
    let viewUI2: UIView = {
        let viewui2 = UIView()
        viewui2.backgroundColor = .orange
        viewui2.translatesAutoresizingMaskIntoConstraints = false
        viewui2.layer.cornerRadius = 10
        return viewui2
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
            viewUI.heightAnchor.constraint(equalToConstant: 100),
            viewUI.widthAnchor.constraint(equalToConstant: 100),
            
            image.topAnchor.constraint(equalTo: viewUI.topAnchor, constant: 5),
            image.leadingAnchor.constraint(equalTo: viewUI.leadingAnchor, constant: 5),
            image.trailingAnchor.constraint(equalTo: viewUI.trailingAnchor, constant: -5),
            image.bottomAnchor.constraint(equalTo: viewUI.bottomAnchor, constant: -5),
            
            textlabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            textlabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            textlabel.widthAnchor.constraint(equalToConstant: 160),
            
            datelabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            datelabel.topAnchor.constraint(equalTo: textlabel.bottomAnchor, constant: 20),
            
            viewUI2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            viewUI2.centerYAnchor.constraint(equalTo: viewUI.centerYAnchor),
            viewUI2.widthAnchor.constraint(equalToConstant: 60),
            viewUI2.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func settingView() {
        self.addSubview(viewUI)
        self.addSubview(textlabel)
        self.addSubview(image)
        self.addSubview(datelabel)
        self.addSubview(viewUI2)
        
    }
    
}
