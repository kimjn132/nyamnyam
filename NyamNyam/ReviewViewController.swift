//
//  ReviewViewController.swift
//  PFoodWish
//
//  Created by 박예진 on 2023/02/01.
//

import UIKit

class ReviewViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tvContents: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    let photo = UIImagePickerController() //앨범 이동
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 앨범 컨트롤러 딜리게이트 지정
//        self.photo.delegate = self
    }
    
    @IBAction func btnPhoto(_ sender: UIButton) {
//        PHPhotoLibrary.requestAuthorization({status in
//            switch status{
//            case .authorized:
//                //앨범 열기 수행 실시
//                self.openPhoto()
//                break
//            case .denied:
//                //앨범 열기 권한 거부
//                break
//
//            case .notDetermined:
//                // 똑같이 앨범 열기 불가능
//                break
//            default:
//                break
//            }
//
//        })
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: [앨범 선택한 이미지 정보를 확인 하기 위한 딜리게이트 선언]
//    extension ReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//        // MARK: [사진, 비디오 선택을 했을 때 호출되는 메소드]
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let img = info[UIImagePickerController.InfoKey.originalImage]{
//
//                // [앨범에서 선택한 사진 정보 확인]
//                print("")
//                print("====================================")
//                print("[A_Image >> imagePickerController() :: 앨범에서 선택한 사진 정보 확인 및 사진 표시 실시]")
//                //print("[사진 정보 :: ", info)
//                print("====================================")
//                print("")
//
//
//                // [이미지 뷰에 앨범에서 선택한 사진 표시 실시]
//                self.imageView.image = img as? UIImage
//
//
//                // [이미지 데이터에 선택한 이미지 지정 실시]
//                self.imageData = (img as? UIImage)!.jpegData(compressionQuality: 0.8) as NSData? // jpeg 압축 품질 설정
//                /*
//                 print("")
//                 print("===============================")
//                 print("[A_Image >> imagePickerController() :: 앨범에서 선택한 사진 정보 확인 및 사진 표시 실시]")
//                 print("[imageData :: ", self.imageData)
//                 print("===============================")
//                 print("")
//                 // */
//
//
//                // [멀티파트 서버에 사진 업로드 수행]
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // [1초 후에 동작 실시]
//                    self.requestPOST()
//                }
//            }
//
//            // [이미지 파커 닫기 수행]
//            dismiss(animated: true, completion: nil)
//        }
//
//
//
//
//        // MARK: [사진, 비디오 선택을 취소했을 때 호출되는 메소드]
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            print("")
//            print("===============================")
//            print("[A_Image >> imagePickerControllerDidCancel() :: 사진, 비디오 선택 취소 수행 실시]")
//            print("===============================")
//            print("")
//
//            // [이미지 파커 닫기 수행]
//            self.dismiss(animated: true, completion: nil)
//
//        }
//    }//END
//
}
