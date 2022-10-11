//
//  PreviewView.swift
//  VideoRecorder
//
//  Created by 엄철찬 on 2022/10/11.
//

import UIKit
import AVFoundation

class PreviewView : UIView {
    override class var layerClass: AnyClass{
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer : AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session : AVCaptureSession? {
        get {
            videoPreviewLayer.session
        }set{
            videoPreviewLayer.session = newValue
        }
    }
}
