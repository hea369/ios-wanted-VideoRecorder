//
//  FirstPageViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit

class FirstPageViewController: UIViewController {
    
    let date = Date()
    
    let dum: [String] = ["텍스트입니다.텍스트입니다.",
                         "텍스트입니다.",
                         "텍스트입니다.",
                         "텍스트입니다.",
                         "텍스트입니다.",
                         "텍스트입니다.",
                         "텍스트입니다.",
                         "텍스트입니다.",
                         "텍스트입니다.",
                         "텍스트입니다."
    ]
    
    let img = ["suit.diamond", "suit.heart", "suit.club", "suit.diamond", "suit.heart", "suit.club", "suit.club", "suit.heart", "suit.club", "suit.club"]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FirstPageTableViewCell.self, forCellReuseIdentifier: FirstPageTableViewCell.identifier)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        tableViewLayout()
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    private func tableViewLayout() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
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
        cell.datelabel.text = "2022-10-12"
        cell.image2.image = UIImage(systemName: "ellipsis")
        cell.image3.image = UIImage(systemName: "arrowshape.forward.fill")
        cell.timelabel.text = "03:20"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerview = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView else { return UIView() }
        
        headerview.textlabel.text = "Video List"

        return headerview
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
}
