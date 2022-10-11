//
//  SecondPageViewController.swift
//  VideoRecorder
//
//  Created by 엄철찬 on 2022/10/11.
//

import UIKit
import AVFoundation

class SecondPageViewController: UIViewController {
    
//    let previewView = PreviewView()
//
//    let captureSession = AVCaptureSession()
//
//    var captureDevice : AVCaptureDevice?
//
//    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFocus))
    
//    private let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        //view.addGestureRecognizer(tapGesture)
        askPermissionForCamera()
    }
    
//    @objc func tapFocus(_ sender:UITapGestureRecognizer){
//        if (sender.state == .ended) {
//              let thisFocusPoint = sender.location(in: view)
//              focusAnimationAt(thisFocusPoint)
//
//              let focus_x = thisFocusPoint.x / view.frame.size.width
//              let focus_y = thisFocusPoint.y / view.frame.size.height
//
//              if (captureDevice!.isFocusModeSupported(.autoFocus) && captureDevice!.isFocusPointOfInterestSupported) {
//                  do {
//                      try captureDevice?.lockForConfiguration()
//                      captureDevice?.focusMode = .autoFocus
//                      captureDevice?.focusPointOfInterest = CGPoint(x: focus_x, y: focus_y)
//
//                      if (captureDevice!.isExposureModeSupported(.autoExpose) && captureDevice!.isExposurePointOfInterestSupported) {
//                          captureDevice?.exposureMode = .autoExpose;
//                          captureDevice?.exposurePointOfInterest = CGPoint(x: focus_x, y: focus_y);
//                       }
//
//                      captureDevice?.unlockForConfiguration()
//                  } catch {
//                      print(error)
//                  }
//              }
//          }
//    }
//
//    fileprivate func focusAnimationAt(_ point: CGPoint) {
//        let focusView = UIImageView(image: UIImage(named: "aim"))
//        focusView.center = point
//        view.addSubview(focusView)
//
//        focusView.transform = CGAffineTransform(scaleX: 2, y: 2)
//
//        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
//            focusView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
//        }) { (success) in
//            UIView.animate(withDuration: 0.15, delay: 1, options: .curveEaseInOut, animations: {
//                focusView.alpha = 0.0
//            }) { (success) in
//                focusView.removeFromSuperview()
//            }
//        }
//    }
    
    func askPermissionForCamera(){   //앱 시작하자마자 권한 요청을 하지 않은 것은 비디오를 녹화하지 않아도 이미 촬영된 영상들을 감상하는 목적으로 사용할 수도 있을 것이라고 생각했기 때문이다
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized :
            print("")
           // setupCaptureSession()
        case .notDetermined :
            DispatchQueue.main.async {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in  //The requestAccess(for:completionHandler:) method is asynchronous
                    if granted {
                      //  self.setupCaptureSession()
                    }
                }
                                              )
            }
        case .denied :
            showAlertGoToSetting()
        case .restricted :
            print("asd")
        @unknown default:
            dismiss(animated: true)
            fatalError()
        }
    }

    func showAlertGoToSetting() {
        let alertController = UIAlertController(
          title: "현재 카메라 사용에 대한 접근 권한이 없습니다.",
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
          self.present(alertController, animated: true) // must be used from main thread only
        }
      }
    
//    func setupCaptureSession(){
//        //start
//        captureSession.beginConfiguration()
//        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
//
//        captureDevice = videoDevice
//
//        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput) else { return }
//        captureSession.addInput(videoDeviceInput)
//        //Next, add outputs for the kinds of media you plan to capture from the camera
//        let videoOutput = AVCaptureMovieFileOutput()
//        guard captureSession.canAddOutput(videoOutput) else { return }
//        captureSession.sessionPreset = .high
//        captureSession.addOutput(videoOutput)
//        //end
//        captureSession.commitConfiguration()
//        setupLivePreview()
//        startCaptureSession()
//
////        self.previewView.session = captureSession
////
////        self.view.addSubview(previewView)
////
////        previewView.translatesAutoresizingMaskIntoConstraints = false
////
////        NSLayoutConstraint.activate([
////            previewView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
////            previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
////            previewView.widthAnchor.constraint(equalTo: view.widthAnchor),
////            previewView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
////        ])
//
//    }
//
//    func setupLivePreview(){
//        // previewLayer 세팅
//        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer.videoGravity = .resizeAspectFill
//        videoPreviewLayer.connection?.videoOrientation = .portrait
//
//        // UIView객체인 view 위 객체 입힘
//        self.view.layer.insertSublayer(videoPreviewLayer, at: 0)  // 맨 앞(0번쨰로)으로 가져와서 보이게끔 설정
//        DispatchQueue.main.async {
//                videoPreviewLayer.frame = self.view.bounds
//        }
//    }
//
//    func startCaptureSession(){
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.captureSession.startRunning()
//        }
//    }
    
    
    


}
