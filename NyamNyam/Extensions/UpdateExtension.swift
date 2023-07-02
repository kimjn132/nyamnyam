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
extension UpdateViewController: UITextViewDelegate, StoreModelProtocol {
    func itemdownloaded(items: [Store]) {
        
    }
    
    
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
    

    
    // textview 디자인 함수들 -----
    // 1. textview에 입력된 글이 없을 시 placeholder를 띄운다.
    func textViewDidEndEditing(_ textView: UITextView) {
        screenUpDownforKeyboard()
        if tvContent.text.isEmpty {
            tvContent.text = placeholder
            tvContent.textColor = .lightGray
        }
    }
    
    // 2. 사용자가 입력을 시작한 경우 placeholder를 비운다.
    func textViewDidBeginEditing(_ textView: UITextView) {
        screenUpDownforKeyboard()
        if tvContent.textColor == .lightGray {
            tvContent.text = nil
            tvContent.textColor = UIColor.black
        }
    }
    

    private func screenUpDownforKeyboard() {
        // 옵저버 등록 - textview 클릭시 키보드만큼 화면이 올라가도록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //textView 선택시 키보드가 올라가는 만큼 화면 올리기
    @objc func keyboardUp(notification: NSNotification) {
        
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    
    @objc func keyboardDown() {
        
        self.view.transform = .identity
        
    }
    
}// db extension

