//
//  ImageInsert.swift
//  MyWish
//
//  Created by 예띤 on 2023/02/18.
//

import Foundation
import AVFoundation
import Photos
import UIKit

class ImageInsert{
    let photo = UIImagePickerController()   //앨범 이동
    var imageData : NSData? = nil   // 서버로 이미지 등록을 하기 위함
    
    // 카메라 호출
    func checkCameraPermission(){
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("Camera: 권한 허용")
            } else {
                print("Camera: 권한 거부")
            }
        })
    }// 카메라 호출
}
