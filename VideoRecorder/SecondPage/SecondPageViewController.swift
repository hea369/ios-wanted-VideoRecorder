//
//  SecondPageViewController.swift
//  VideoRecorder
//
//  Created by 엄철찬 on 2022/10/11.
//

import UIKit
import AVKit
import AVFoundation
import CoreMotion
import CoreData

class SecondPageViewController: UIViewController {
    
    var timer: Timer?
    var secondsOfTimer = 0
    var motionManager: CMMotionManager!
        
    let request : NSFetchRequest<Title> = Title.fetchRequest()

    let captureSession = AVCaptureSession()
    var videoDevice : AVCaptureDevice!
    var audioDevice : AVCaptureDevice!
    var videoInput : AVCaptureDeviceInput!
    var audioInput : AVCaptureDeviceInput!
    var videoOutput: AVCaptureMovieFileOutput!
    
    var deviceOrientation: AVCaptureVideoOrientation = .portrait{
        willSet{
            rotateAnimation(deviceOrientation)
        }
    }
    var videoURL : URL?

    let directoryPath : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VideoRecorder")
    
    var videoTitle : String?
    var videoOrientation : AVCaptureVideoOrientation?
    
    func setCloseView(){
        view.addSubview(closeView)
        closeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeView.widthAnchor.constraint(equalToConstant: 30),
            closeView.heightAnchor.constraint(equalToConstant: 30),
            closeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            closeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        closeView.layer.cornerRadius = 15
        closeView.addGestureRecognizer(tapGesture)
    }
    
    func setControlView(){
        view.addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controlView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            controlView.heightAnchor.constraint(equalToConstant: 100),
            controlView.centerYAnchor.constraint(equalTo: view.centerYAnchor).withMultiplier(1.7),
            controlView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


    let controlView = ControlView()
    let closeView = CloseView()
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        askPermissionForMicrophone()
        askPermissionForCamera()
        initMotionManager()
        setControlView()
        setCloseView()
        controlView.delegate = self
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//      super.viewWillAppear(animated)
//      initMotionManager()
//      if !captureSession.isRunning {
//          startCaptureSession()
//      }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//      super.viewWillDisappear(animated)
//      motionManager.stopAccelerometerUpdates()
//      stopTimer()
//    }
    
    @objc func close(){
        self.dismiss(animated: true)
    }
    
    
    func askPermissionForCamera(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized :
            setupCaptureSession()
        case .notDetermined :
            DispatchQueue.main.async {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                    if granted {
                        self.setupCaptureSession()
                    }
                })
            }
        case .denied :
            showAlertGoToSetting(device: "카메라")
        case .restricted :
            break
        @unknown default:
            fatalError()
        }
    }
    
    func askPermissionForMicrophone(){
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Mic: 권한 허용")
                } else {
                    self.showAlertGoToSetting(device: "마이크")
                }
            })
        }
    
    func showAlertGoToSetting(device : String) {
        let alertController = UIAlertController(
            title: "현재 \(device) 사용에 대한 접근 권한이 없습니다.",
            message: "설정 > VideoRecorder 탭에서 접근을 활성화 할 수 있습니다.",
            preferredStyle: .alert
        )
        let cancelAlert = UIAlertAction(
            title: "취소",
            style: .cancel
        ) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true)
        }
        let goToSettingAlert = UIAlertAction(
            title: "설정으로 이동하기",
            style: .default) { _ in
                guard
                    let settingURL = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(settingURL)
                else { return }
                UIApplication.shared.open(settingURL, options: [:])
            }
        [cancelAlert, goToSettingAlert]
            .forEach(alertController.addAction(_:))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    func setupCaptureSession(){
        //start
        captureSession.beginConfiguration()
        videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
        
        //videoDevice = videoDevice
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice), captureSession.canAddInput(videoDeviceInput) else { return }
        
        self.videoInput = videoDeviceInput
        
        captureSession.addInput(videoInput)
        
        audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
        audioInput = try? AVCaptureDeviceInput(device: audioDevice)
        if captureSession.canAddInput(audioInput){
            captureSession.addInput(audioInput)
        }
       
        videoOutput = AVCaptureMovieFileOutput()
      
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.sessionPreset = .high
        captureSession.addOutput(videoOutput)
        //end
        captureSession.commitConfiguration()
        setupLivePreview()
        startCaptureSession()
    }
    
    func setupLivePreview(){
    
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill  //가득
        videoPreviewLayer.connection?.videoOrientation = .portrait
     
        self.view.layer.insertSublayer(videoPreviewLayer, at: 0)
        DispatchQueue.main.async {
            videoPreviewLayer.frame = self.view.bounds
        }
    }
    
    func startCaptureSession(){
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    
    private func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
        var deviceTypes: [AVCaptureDevice.DeviceType]!
        
        if #available(iOS 11.1, *) {
            deviceTypes = [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera]
        } else {
            deviceTypes = [.builtInDualCamera, .builtInWideAngleCamera]
        }
        
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: .video,
            position: .unspecified
        )
        
        let devices = discoverySession.devices
        guard !devices.isEmpty else { fatalError("Missing capture devices.")}
        
        return devices.first(where: { device in device.position == position })!
    }
 
}


//MARK: - 카메라 전환 버튼, 촬영 버튼
extension SecondPageViewController : ControlViewDelegate{
    func rollCamera() {
        if videoOutput.isRecording{
            controlView.redButtonStopAnimation()
            stopRecording()
        }else{
            controlView.redButtonRecordingAnimation()
            startRecording()
        }
    }
    
    
    func switchCamera() {

        guard let inputVideo = captureSession.inputs[0] as? AVCaptureDeviceInput else {return}
        guard let inputAudio = captureSession.inputs[1] as? AVCaptureDeviceInput else {return}
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        var newDevice: AVCaptureDevice?
        if inputVideo.device.position == .back {
            newDevice = bestDevice(in: .front)
        } else {
            newDevice = bestDevice(in: .back)
        }
        
        do {
            videoInput = try AVCaptureDeviceInput(device: newDevice!)
            audioInput = try AVCaptureDeviceInput(device: audioDevice)
        } catch let error {
            NSLog("\(error), \(error.localizedDescription)")
            return
        }

            captureSession.removeInput(inputVideo)
            captureSession.addInput(videoInput)

            captureSession.removeInput(inputAudio)
            captureSession.addInput(audioInput)
    }
  
}

//MARK: - 비디오 관련
extension SecondPageViewController : AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        videoURL = outputFileURL
        getTitle()
    }
    
    private func startRecording() {
      let connection = videoOutput.connection(with: AVMediaType.video)
      
      if (connection?.isVideoOrientationSupported)! {
        connection?.videoOrientation = self.deviceOrientation
          videoOrientation = self.deviceOrientation
      }
      
      let device = videoInput.device
      if (device.isSmoothAutoFocusSupported) {
        do {
          try device.lockForConfiguration()
          device.isSmoothAutoFocusEnabled = false
          device.unlockForConfiguration()
        } catch {
          print("Error setting configuration: \(error)")
        }
      }

      self.startTimer()
      videoURL = tempURL()
      videoOutput.startRecording(to: videoURL!, recordingDelegate: self)
    }
    
    private func stopRecording() {
      if videoOutput.isRecording {
        self.stopTimer()
        videoOutput.stopRecording()
      }
    }
    
    func save(_ title:String){
        let fileURL = directoryPath.appendingPathComponent(title).appendingPathExtension("mp4")
        do{
            let videoData = try Data(contentsOf: videoURL!)
            try videoData.write(to: fileURL , options: .atomic)
        }catch{
            print(error.localizedDescription)
        }
    }
    func saveModel(_ title:String){
        let model = VideoModel(title: title, date: Date(), playTime: secondsOfTimer, orientation: videoOrientation?.rawValue ?? 1)
        let modelURL = directoryPath.appendingPathComponent(title).appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(model)
        do{
            try data?.write(to: modelURL)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    private func tempURL() -> URL? {
      let directory = NSTemporaryDirectory() as NSString
      
      if directory != "" {
        let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
        return URL(fileURLWithPath: path)
      }
      return nil
    }
    
}


//MARK: - 알림
extension SecondPageViewController {
    
    func getTitle() {
        let alert = UIAlertController(title: "녹화 완료", message: "동영상 제목을 입력해주세요", preferredStyle: .alert)
        alert.addTextField()
        let ok    = UIAlertAction(title: "확인", style: .default){ _ in
            self.videoTitle = alert.textFields?[0].text
            let titles = CoreDataManager.shared.fetch(request: self.request).compactMap{$0.title}
            if titles.contains(self.videoTitle!){
                let alert = UIAlertController(title: "주의!", message: "같은 이름의 동영상이 이미 있습니다", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .destructive)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }else{
                CoreDataManager.shared.insert(title: self.videoTitle!)
                self.save(self.videoTitle!)
                self.saveModel(self.videoTitle!)
            }
            self.secondsOfTimer = 0
        }
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
}


//MARK: - 타이머
extension SecondPageViewController {
    private func startTimer() {
      timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
        guard let `self` = self else { return }
        self.secondsOfTimer += 1
          self.controlView.timeLabel.text = Double(self.secondsOfTimer).format(units: [.minute, .second])
      }
    }
    
    private func stopTimer() {
      timer?.invalidate()
      self.controlView.timeLabel.text = "00:00"
    }
}


//MARK: - 화면이 Lock 상태에서도 방향 구하기
extension SecondPageViewController {
    private func initMotionManager() {
      motionManager = CMMotionManager()
      motionManager.accelerometerUpdateInterval = 0.2
      motionManager.gyroUpdateInterval = 0.2
      
      motionManager.startAccelerometerUpdates( to: OperationQueue() ) { [weak self] accelerometerData, _ in
        guard let data = accelerometerData else { return }
        
        if abs(data.acceleration.y) < abs(data.acceleration.x) {
          if data.acceleration.x > 0 {
            self?.deviceOrientation = .landscapeLeft
          } else {
            self?.deviceOrientation = .landscapeRight
          }
        } else {
          if data.acceleration.y > 0 {
            self?.deviceOrientation = .portraitUpsideDown
          } else {
            self?.deviceOrientation = .portrait
          }
        }
      }
    }
}

//MARK: - 방향 회전
extension SecondPageViewController {
    
    func rotateAnimation(_ orientation:AVCaptureVideoOrientation){
        let componentsArr = [self.controlView.timeLabel, self.controlView.switchButton]
        var scale : CGAffineTransform = .identity
        switch orientation.rawValue{
        case 1:
            scale = .identity
        case 2:
            scale = CGAffineTransform(rotationAngle: .pi)
        case 3:
            scale = CGAffineTransform(rotationAngle: .pi / 2)
        case 4:
            scale = CGAffineTransform(rotationAngle: .pi * 1.5)
        default:
            print("error")
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5){
                _ = componentsArr.map{ $0.transform = scale }
            }
        }
    }
}
