//
//  FirstPageViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit

class FirstPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        setCameraButton()
        setTableView()
    }
    
    let tableView = UITableView()
    
    func configTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.id)
        tableView.rowHeight = 100
    }
    
    func setTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setCameraButton(){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    lazy var button : UIButton = {
       let btn = UIButton()
        btn.setTitle("녹화하기", for: .normal)
        btn.addTarget(self, action: #selector(moveToSecondPage), for: .touchUpInside)
        btn.backgroundColor = .cyan
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    @objc func moveToSecondPage(){
        let secondVC = SecondPageViewController()
        secondVC.modalTransitionStyle = .crossDissolve
        secondVC.modalPresentationStyle = .fullScreen
        present(secondVC, animated: true)
    }
    
}

extension FirstPageViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id) as? CustomCell else { return UITableViewCell() }
        cell.thumbnailView.setInfo(img: UIImage(systemName: "camera")!, time: "3:21")
        cell.setInfo(title: "Fish.mp4", date: "2022-10-31")
        return cell
    }
    
    
}


extension FirstPageViewController : UITableViewDelegate {
    
}

class CustomCell : UITableViewCell {
    
    static let id = "cell"
    
    let thumbnailView = Thumbnail()
    let title         = UILabel()
    let date          = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraint(){
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnailView)
        contentView.addSubview(title)
        contentView.addSubview(date)

        NSLayoutConstraint.activate([
            thumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            thumbnailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            thumbnailView.widthAnchor.constraint(equalTo: thumbnailView.heightAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            date.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            date.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    func setInfo(title:String, date:String){
        self.title.text = title
        self.date.text = date
    }
}

class Thumbnail : UIView {
    let imageView = UIImageView()
    let duration  = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraint(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        duration.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.addSubview(duration)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            duration.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            duration.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    func setInfo(img:UIImage,time:String){
        self.imageView.image = img
        self.duration.text   = time
    }
}
