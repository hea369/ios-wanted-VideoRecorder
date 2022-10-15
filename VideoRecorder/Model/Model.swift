//
//  Model.swift
//  VideoRecorder
//
//  Created by 박호현 on 2022/10/15.
//

import Foundation

struct VideoModel: Codable {
    let title : String
    let date  : Date
    let playTime : Int
    let orientation : Int
}
