//
//  VideoHelper.swift
//  VideoRecorder
//
//  Created by 엄철찬 on 2022/10/12.
//

import MobileCoreServices
import UIKit
import UniformTypeIdentifiers


enum VideoHelper {
    static func startMediaBrowser(delegate:UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate, sourceType : UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return } //Checks if the source is available on the device. Sources include the camera roll, the camera itself and the full photo library. This check is essential whenever you use UIImagePickerController to pick media. If you don’t do it, you might try to pick media from a non-existent source, which will usually result in a crash.
        let mediaUI = UIImagePickerController() //If the source you want is available, it creates a UIImagePickerController and sets its source and media type.
        mediaUI.sourceType = sourceType
        mediaUI.mediaTypes = [UTType.movie.identifier]  //Since you only want to select videos, the code restricts the type to kUTTypeMovie.
        mediaUI.allowsEditing = false
        mediaUI.videoQuality = .typeHigh
        mediaUI.delegate = delegate
        delegate.present(mediaUI, animated: true)   //Finally, it presents UIImagePickerController modally.
    }
}
