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
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    
        // Do any additional setup after loading the view.
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
