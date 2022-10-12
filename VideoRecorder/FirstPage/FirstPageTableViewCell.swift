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
        label.textColor = UIColor.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: CGFloat(30))
        return label
    }()
    
    let datelabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let image: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .yellow
        imageview.image = UIImage(named: "")
        imageview.translatesAutoresizingMaskIntoConstraints = false
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
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            //        image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            
            textlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            textlabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            textlabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    func settingView() {
        self.addSubview(textlabel)
        self.addSubview(image)
        
    }
    
}
