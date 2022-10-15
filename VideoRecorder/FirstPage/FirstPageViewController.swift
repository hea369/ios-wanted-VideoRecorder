//
//  FirstPageViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit
import AVKit //AVKit gives you access to AVPlayer, which plays the selected video.
import MobileCoreServices  //MobileCoreServices contains predefined constants such as kUTTypeMovie
import Photos //access the photo library, PhotoKit is the answer.
import CoreData

class FirstPageViewController: UIViewController {
    
    //MARK: 따로
    var videoURL : URL?

    let directoryPath : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VideoRecorder")
    
    var model : [VideoModel] = []
    
    let request : NSFetchRequest<Title> = Title.fetchRequest()

    func creatDirectory(){
        do{
            try FileManager.default.createDirectory(at: directoryPath, withIntermediateDirectories: false)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadTableView()
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        setCameraButton()
        setTableView()
//        askForLibraryPermission{ granted in
//            guard granted else { return }
//            self.fetchAssests()
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
        
        creatDirectory()
        
    }
    
    

    
    let tableView = UITableView()
    private var allPhotos = PHFetchResult<PHAsset>()
    private var smartAlbums = PHFetchResult<PHAssetCollection>()
    private var userCollections = PHFetchResult<PHAssetCollection>()
    
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
        let img = UIImage(systemName: "camera")
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(camera), for: .touchUpInside)
        btn.tintColor = .systemBlue
        return btn
    }()
    
    @objc func camera(){
        let secondVC = SecondPageViewController()
        secondVC.modalTransitionStyle = .crossDissolve
        secondVC.modalPresentationStyle = .fullScreen
        present(secondVC, animated: true)
      //  VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    
//    func askForLibraryPermission(completionHandler:@escaping (Bool) -> Void){
//        //get the current authorization status from PHPhotoLibrary. If it’s already authorized, call the completion handler with a value of true.
//        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
//            completionHandler(true)
//            return
//        }
//        //If permission was not previously granted, request it. When requesting authorization, iOS displays an alert dialog box asking for permission.
//        PHPhotoLibrary.requestAuthorization{ status in
//            //It passes back the status as a PHAuthorizationStatus object in its completion handler.
//            completionHandler(status == .authorized)
//        }
//        //PHAuthorizationStatus is an enum, which can also return notDetermined, restricted, denied and, new to iOS 14, limited
//    }
    
//    func fetchAssests(){
//        //When fetching assets, you can apply a set of options that dictate the sorting, filtering and management of results.
//        let allPhotosOptions = PHFetchOptions()
//        allPhotosOptions.sortDescriptors = [
//            NSSortDescriptor(key: "creationDate", ascending: false)
//        ]
//        //PHAsset provides functionality for fetching assets and returning the results as a PHFetchResult
//        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
//        //The Photos app automatically creates smart albums, such as Favorites and Recents. Albums are a group of assets and, as such, belong in PHAssetCollection objects. Here you fetch smart album collections. You won’t sort these, so options is nil.
//        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
//        //Accessing user created albums is similar, except that you fetch the .album type.
//        userCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
//    }
    
}

extension FirstPageViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id) as? CustomCell else { return UITableViewCell() }
        let info = model[indexPath.row]
        let videoURL = directoryPath.appendingPathComponent(info.title).appendingPathExtension("mp4")
        let thumbnail = getThumbnailImage(forUrl: videoURL) ?? UIImage()
        cell.thumbnailView.setInfo(img: thumbnail, time: Double(info.playTime).format(units: [.minute, .second]))
        rotateThumbnail(orientation: info.orientation, viewToRotate: cell.thumbnailView.imageView)
        cell.setInfo(title: info.title, date: dateToString(info.date))

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

extension FirstPageViewController : UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)    //PHPicker 사용해보기
        let title = model[indexPath.row].title
        let videoPath = directoryPath.appendingPathComponent(title).appendingPathExtension("mp4")
        if FileManager.default.fileExists(atPath: videoPath.path ){
            do{
                let player = AVPlayer(url: videoPath)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                //playerViewController.showsPlaybackControls = false
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

//extension FirstPageViewController : UIImagePickerControllerDelegate{//You’ll use the system-provided UIImagePickerController to let the user browse videos in the photo library.
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print("called!!")
//        if picker.sourceType == UIImagePickerController.SourceType.camera{
//            dismiss(animated: true)
//            //As before, the delegate method gives you a URL pointing to the video.
//            guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String, mediaType == UTType.movie.identifier, let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL, UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path()) else { return }
//            //Verify that the app can save the file to the device’s photo album.
//            //If it can, save it.
//            UISaveVideoAtPathToSavedPhotosAlbum(url.path(), self, #selector(video), nil)
//        }else{
//            //You get the media type of the selected media and URL and ensure it’s a video.
//            guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String, mediaType == UTType.movie.identifier, let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
//            //you dismiss the image picker.
//            dismiss(animated: true){
//                //In the completion block, you create an AVPlayerViewController to play the media.
//                let player = AVPlayer(url: url)
//                let vcPlayer = AVPlayerViewController()
//                vcPlayer.player = player
//                self.present(vcPlayer, animated: true)
//            }
//        }
//    }
//    //The callback method simply displays an alert to the user, announcing whether the video file was saved or not, based on the error status.
//    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject){
//        let title = (error == nil) ? "Success" : "Error"
//          let message = (error == nil) ? "Video was saved" : "Video failed to save"
//          let alert = UIAlertController(
//            title: title,
//            message: message,
//            preferredStyle: .alert)
//          alert.addAction(UIAlertAction(
//            title: "OK",
//            style: UIAlertAction.Style.cancel,
//            handler: nil))
//          present(alert, animated: true, completion: nil)
//    }
//
//}
//
//extension FirstPageViewController : UINavigationControllerDelegate{
//
//}





















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
        if (imageView.image?.size.height)! > (imageView.image?.size.width)!{
            imageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }
    }
}




//MARK: - 나중에 따로
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
    
    func dateToString(_ date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func rotateThumbnail(orientation:Int, viewToRotate:UIView){
        switch orientation{
        case 1: viewToRotate.transform = CGAffineTransform(rotationAngle: .pi / 2)
        case 2: viewToRotate.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        case 3: viewToRotate.transform = CGAffineTransform(rotationAngle: .pi * 2)
        case 4: viewToRotate.transform = CGAffineTransform(rotationAngle: .pi)
        default: print("no case")
        }
    }
}
