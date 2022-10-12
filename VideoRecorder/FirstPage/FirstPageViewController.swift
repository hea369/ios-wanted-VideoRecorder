//
//  FirstPageViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit

class FirstPageViewController: UIViewController {
    
    let date = Date()
    
    let dum: [String] = ["sssssssssssssssssssssssssssssssssssssssssssssssssssssss",
                         "ssssssssssssssssssssssssssssssssssssssssssss",
                         "sssssssssssssssssssssssssssssssss",
                         "ssssssssssssssssssssssssssssssssssssssssssss",
                         "ssssssssssssssssssssss",
                         "ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss",
                         "s",
                         "sssss",
                         "aa",
                         "aaaa"
    ]
    
    let img = ["suit.diamond", "suit.heart", "suit.club", "suit.diamond", "suit.heart", "suit.club", "suit.club", "suit.heart", "suit.club", "suit.club"]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(FirstPageTableViewCell.self, forCellReuseIdentifier: FirstPageTableViewCell.identifier)
        tableView.backgroundColor = .green
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        tableViewLayout()
        
    }
    
    private func tableViewLayout() {
        
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = view.frame.size.height / 10
    }
    
    private func addConTentView() {
        
    }
    
}

extension FirstPageViewController: UITableViewDelegate {
    
}

extension FirstPageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FirstPageTableViewCell.identifier, for: indexPath) as? FirstPageTableViewCell else { return UITableViewCell() }
        cell.textlabel.text = dum[indexPath.row]
        cell.image.image = UIImage(systemName: img[indexPath.row])
        return cell
    }

}
