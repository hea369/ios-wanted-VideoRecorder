//
//  FirstPageViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit
import AVKit
import CoreData

class FirstPageViewController: UIViewController {
    var model : [VideoModel] = []
    let request : NSFetchRequest<Title> = Title.fetchRequest()
    var videoURL : URL?
    
    let directoryPath : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VideoRecorder")
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FirstPageTableViewCell.self, forCellReuseIdentifier: FirstPageTableViewCell.identifier)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configure()
        tableViewLayout()
        tableView.rowHeight = UITableView.automaticDimension
        creatDirectory()
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
    
    func dateToString(_ date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func rotateThumbnail(orientation:Int, viewToRotate:UIView) {
        switch orientation{
        case 1: viewToRotate.transform = CGAffineTransform(rotationAngle: .pi / 2)
        case 2: viewToRotate.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        case 3: viewToRotate.transform = CGAffineTransform(rotationAngle: .pi * 2)
        case 4: viewToRotate.transform = CGAffineTransform(rotationAngle: .pi)
        default: print("no case")
        }
    }
    
    @objc func camera(){
        let secondVC = SecondPageViewController()
        secondVC.modalTransitionStyle = .crossDissolve
        secondVC.modalPresentationStyle = .fullScreen
        present(secondVC, animated: true)
    }
}

extension FirstPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = model[indexPath.row].title
        let videoPath = directoryPath.appendingPathComponent(title).appendingPathExtension("mp4")
        if FileManager.default.fileExists(atPath: videoPath.path ){
            do{
                let player = AVPlayer(url: videoPath)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }catch{
                print(error.localizedDescription)
            }
        }else{
            print("No Video")
        }
    }
    
}

extension FirstPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FirstPageTableViewCell.identifier, for: indexPath) as? FirstPageTableViewCell else { return UITableViewCell() }
        let info = model[indexPath.row]
        let videoURL = directoryPath.appendingPathComponent(info.title).appendingPathExtension("mp4")
        let thumbnail = getThumbnailImage(forUrl: videoURL) ?? UIImage()
        
        cell.image.image = thumbnail
        cell.timelabel.text = Double(info.playTime).format(units: [.minute, .second])
        cell.textlabel.text = info.title
        cell.datelabel.text = dateToString(info.date)
        rotateThumbnail(orientation: info.orientation, viewToRotate: cell.image)
        cell.image2.image = UIImage(systemName: "ellipsis")
        cell.image3.image = UIImage(systemName: "arrowshape.forward.fill")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerview = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView else { return UIView() }
        
        headerview.videoButton.addTarget(self, action: #selector(camera), for: .touchUpInside)
        headerview.textlabel.text = "Video List"
        
        return headerview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView( _ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let targetTitle = model[indexPath.row].title
            var targetForCoreData = Title()
            _ = CoreDataManager.shared.fetch(request: request).map{
                if $0.title == targetTitle{
                    targetForCoreData = $0
                }
            }
            CoreDataManager.shared.delete(object: targetForCoreData)
            let videoURL = directoryPath.appendingPathComponent(targetTitle).appendingPathExtension("mp4")
            let modelURL = directoryPath.appendingPathComponent(targetTitle).appendingPathExtension("json")
            try? FileManager.default.removeItem(at: videoURL)
            try? FileManager.default.removeItem(at: modelURL)
            model.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension FirstPageViewController {
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func reloadTableView(){
        let titles : [Title] = CoreDataManager.shared.fetch(request: request)
        model.removeAll()
        titles.forEach{
            let modelPath = directoryPath.appendingPathComponent($0.title ?? "").appendingPathExtension("json")
            if FileManager.default.fileExists(atPath: modelPath.path){
                do{
                    let jsonDecoder = JSONDecoder()
                    let data = try Data(contentsOf: modelPath)
                    let model = try jsonDecoder.decode(VideoModel.self, from: data)
                    self.model.append(VideoModel(title: model.title, date: model.date, playTime: model.playTime,orientation: model.orientation))
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        model.reverse()
        self.tableView.reloadData()
    }
    
    
    func creatDirectory(){
        do{
            try FileManager.default.createDirectory(at: directoryPath, withIntermediateDirectories: false)
        }catch{
            print(error.localizedDescription)
        }
    }
}
