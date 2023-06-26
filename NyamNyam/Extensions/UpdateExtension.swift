//
//  UpdateExtension.swift
//  NyamNyam
//
//  Created by Anna Kim on 2023/06/26.
//

import Foundation
import UIKit

// ----------------extensions----------------
extension UpdateViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate & KakaoZipCodeDelegate {
    
    
    // MARK: [사진, 비디오 선택을 했을 때 호출되는 메소드]
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.originalImage]{
            
            // [이미지 뷰에 앨범에서 선택한 사진 표시 실시]
            imageView.image = img as? UIImage
            
            // [이미지 데이터에 선택한 이미지 지정 실시]
            imageData = (img as? UIImage)!.jpegData(compressionQuality: 0.8) as NSData? // jpeg 압축 품질 설정
        }
        
        // 이미지 피커 닫기
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: [사진, 비디오 선택을 취소했을 때 호출되는 메소드]
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 이미지 파커 닫기
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func receivedAddress(_ address: AddressModel) {
        newAddress = address
        
    }
    
}// image extension


// db protocol 불러오기
extension UpdateViewController: StoreModelProtocol {
    
    //글자 수 제한 감지
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = tvContent.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= maxCharacters
    }
    
    //글자 수 카운트
    func textViewDidChange(_ textView: UITextView) {
        //placeholderLabel.isHidden = !textView.text.isEmpty
        let currentCount = tvContent.text.count
        let remainingCount = maxCharacters - currentCount
        countLabel.text = "\(remainingCount)/60"
    }
    
    func itemdownloaded(items: [Store]) {

    }
    
}// db extension

