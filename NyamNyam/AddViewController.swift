//
//  AddViewController.swift
//  PFoodWish
//
//  Created by 박예진 on 2023/02/02.
//

import UIKit
import SQLite3

import AVFoundation
import Photos

class AddViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    
    // textView 글자 수 제한 - 60자
    @IBOutlet weak var countLabel: UILabel!
    let maxCharacters = 60
    
    //"한식", "중식", "양식", "일식", "분식", "카페", "기타" 선택 라디오 버튼
    @IBOutlet var radioButtons: [UIButton]!
    let categories = ["한식", "중식", "양식", "일식", "분식", "카페", "기타"]
    // 라디오 버튼 선택 index
    var indexOfBtns: Int?
    // 디폴트 태그: 기타
    var myTag = "기타"

    let photo = UIImagePickerController()   //앨범 이동
    
    var imageData : NSData? = nil   // 서버로 이미지 등록을 하기 위함
    
    // 키보드 올라가는 만큼 화면 올리기 위해 필요한 NotificationCenter
    let notiCenter = NotificationCenter.default
    
    //segue를 통해 Done 버튼 클릭시 메인 피드로 이동
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //segue를 통해 editViewController의 생성자를 만들어서 페이지 넘김
//        let addViewController = segue.destination as! AddViewController //생성자 만들기
        
//        if segue.identifier == "addDoneToMain" {
//            addViewController.textWayValue = "segue: Use Bar Btn"
//        }
//        else{
//            editViewController.textWayValue = "segue: use btn"
//        }
        
//        editViewController.textMessage = tfMessage.text!
//        editViewController.isOn = isOn
//        //연결시키기
//        editViewController.delegate = self
        
//    }
    
    // override funcs ================================================
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 뷰 텍스트 초기화
        tfTitle.text = ""
        imageView.image = UIImage(named: "기타.png")
        tvContent.text = "리뷰를 작성하세요."
        tvContent.textColor = UIColor.systemGray4
        
        //글자 수 제한 countlabel 초기 설정
        countLabel.text = "\(maxCharacters)/60"
        
        // 딜리게이트 지정
        self.photo.delegate = self
        tvContent.delegate = self
        tfTitle.delegate = self

        // 카테고리 버튼 중 하나 기본 선택
//        radioButtons[0].isSelected = true
        
        // ScrollView에서 화면 터치시 키보드 내리기
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
    }//viewDidLoad
    
    // 뷰 화면 표시
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // 뷰 컨트롤러 포그라운드, 백그라운드 상태 체크 설정 실시
        NotificationCenter.default.addObserver(self, selector: #selector(checkForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // 포그라운드 처리 실시
        checkForeground()
        
    }//viewDidAppear
    
    // 뷰 정지 상태
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
    }//viewwillDisappear
    
    // 뷰 종료 상태
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        //뷰 컨트롤러 포그라운드, 백그라운드 상태 체크 해제
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }//viewDiddisappear
    
    // viewWillAppear: 다른 화면에서 다시 올 때 실행된다.
    // kakao api로 가져온 address를 라벨로 띄워준다.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // address label 채워준다.
        if Message.address.isEmpty {
            lblAddress.text = " + 버튼을 눌러 위치를 추가하세요."
            lblAddress.textColor = UIColor.lightGray
            
        } else {
            
            lblAddress.text = " \(Message.address)"
            lblAddress.textColor = UIColor.secondaryLabel
            
        }
        
    }
    
        
    // @IBAction funcs ==================================================
    
    // 맛집 카테고리 클릭 버튼
    @IBAction func btnChooseCategory(_ sender: UIButton) {
        
        if indexOfBtns != nil{

            if !sender.isSelected {
                
                for unselectIndex in radioButtons.indices {
                    
                    radioButtons[unselectIndex].isSelected = false
                }
                
                sender.isSelected = true
                indexOfBtns = radioButtons.firstIndex(of: sender)
                
            } else {
                
                sender.isSelected = false
                indexOfBtns = nil
                
            }
            
        } else {
            
            sender.isSelected = true
            indexOfBtns = radioButtons.firstIndex(of: sender)
            
        }
        
        // myTag에 선택한 카테고리 버튼 값 넣어주기
        var i = 0
        for category in categories {
            if indexOfBtns == i{
                myTag = category
            }
            i += 1
        }
        
        // imageview에 들어간 image가 없거나 디폴트 이미지일 경우 카테고리 버튼을 눌렀을 때 카테고리에 맞는 디폴트 이미지로 바뀜
        // 사용자가 직접 넣은 이미지라면 바뀌지 않는다.
        if ((imageView.image == nil)
            || (imageView.image == UIImage(named: "카페.png"))
            || (imageView.image == UIImage(named: "한식.png"))
            || (imageView.image == UIImage(named: "양식.png"))
            || (imageView.image == UIImage(named: "일식.png"))
            || (imageView.image == UIImage(named: "중식.png"))
            || (imageView.image == UIImage(named: "분식.png"))
            || (imageView.image == UIImage(named: "기타.png"))) {
            
            for category in categories {
                if myTag == category{
                    imageView.image = UIImage(named: category + ".png")
                }
            }
            
        }

    }//btnChooseCategory
    
    // 이미지 추가 버튼 클릭
    @IBAction func btnImage(_ sender: UIButton) {
        
        // 권한 alert
        showAlert()
        
    }//btnImage
    
    // 완료 버튼 클릭시 alert
    @IBAction func btnDone(_ sender: UIBarButtonItem) {
        
//        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController")
        
        if tfTitle.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            let testAlert = UIAlertController(title: nil, message: "맛집 이름을 작성해주세요!", preferredStyle: .alert)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.left
            let messageFont = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 17.0)!]
            let messageAttrString = NSMutableAttributedString(string: "맛집 이름을 작성해주세요!", attributes: messageFont)
            testAlert.setValue(messageAttrString, forKey: "attributedMessage")

            // UIAlertAcrion 설정
            let actionCancel = UIAlertAction(title: "닫기", style: .cancel)
            
            // UIAlertController에 UIAlertAction버튼 추가하기
            testAlert.addAction(actionCancel)
            
            // Alert 띄우기
            present(testAlert, animated: true)
            
        }else if lblAddress.text?.trimmingCharacters(in: .whitespaces) == "+ 버튼을 눌러 위치를 추가하세요."{ // 위치 추가 안하면 Alert
            // Alert
            let testAlert = UIAlertController(title: nil, message: "맛집 위치를 추가해주세요!", preferredStyle: .alert)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.left
            let messageFont = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 17.0)!]
            let messageAttrString = NSMutableAttributedString(string: "맛집 위치를 추가해주세요!", attributes: messageFont)
            testAlert.setValue(messageAttrString, forKey: "attributedMessage")

            // UIAlertAcrion 설정
            let actionCancel = UIAlertAction(title: "닫기", style: .cancel)
            
            // UIAlertController에 UIAlertAction버튼 추가하기
            testAlert.addAction(actionCancel)
            
            // Alert 띄우기
            present(testAlert, animated: true)
        }else if (tvContent.text!.trimmingCharacters(in: .whitespaces).isEmpty) || tvContent.text == "리뷰를 작성하세요."{
            // Alert
            let testAlert = UIAlertController(title: nil, message: "리뷰를 작성해주세요!", preferredStyle: .alert)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.left
            let messageFont = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 17.0)!]
            let messageAttrString = NSMutableAttributedString(string: "리뷰를 작성해주세요!", attributes: messageFont)
            testAlert.setValue(messageAttrString, forKey: "attributedMessage")

            // UIAlertAcrion 설정
            let actionCancel = UIAlertAction(title: "닫기", style: .cancel)
            
            // UIAlertController에 UIAlertAction버튼 추가하기
            testAlert.addAction(actionCancel)
            
            // Alert 띄우기
            present(testAlert, animated: true)
            
        }else{

            // DB에 정보 insert
            dbInsert()
//            self.presentingViewController?.dismiss(animated: true)
//            self.navigationController?.pushViewController(pushVC!, animated: true)
//            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController")
//
//            self.navigationController?.pushViewController(pushVC!, animated: true)
            initPage()
            
        }
        
        

    }
    
//    @IBAction func btnDone(_ sender: UIButton) {
//
//        // DB에 정보 insert
//        dbInsert()
//     // 이렇게 넘어가면 탭바가 없어짐
////        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "TableViewController") else {return}
////        self.present(nextVC, animated: true)
//
//    }//btnDone
    
    // + 버튼 눌렀을 때 kakao api를 불러온다.
    @IBAction func btnAddAddress(_ sender: UIButton) {
        
        let nextVC = KakaoZipCodeVC()
        nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(nextVC, animated: true)
        
    }//btnAddAddress

    // objc funcs ===================================================
    //포그라운드 및 백그라운드 상태 처리 메소드 작성
    @objc func checkForeground(){
    }
    @objc func checkBackground(){
    }
    
    // 터치가 발생할 때 핸들러 캐치 - 화면 터치시 키보드 내리기
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true) // todo...
        }
        sender.cancelsTouchesInView = false
    }
    
    //textView 선택시 키보드가 올라가는 만큼 화면 올리기
    @objc func keyboardUp(notification:NSNotification) {
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
    
    // MARK: - Navigation
    // segue로 넘어갈 때 해제
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        dbInsert()
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        let tableViewController = segue.destination as! TableViewController //생성자 만들기
//
//        //연결시키기
////        tableViewController.delegate = self
//

//
//    }
    
    
    // funcs =========================================================================
    // 사진 alert-----
    func showAlert(){
        
        let alert = UIAlertController(title: "Select One", message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) {(action) in
            
            PHPhotoLibrary.requestAuthorization({status in
                switch status{
                    // 앨범 열기 권한 허용하면 openPhoto()함수 호출
                    case .authorized:
                        self.openPhoto()
                        break
                        
                    // 앨범 열기 권한 거부
                    case .denied:
                        break
                        
                    // 앨범 열기 불가능
                    case .notDetermined:
                        break
                    
                    // 디폴트
                    default:
                        break
                }
            })
            
        }
        let camera = UIAlertAction(title: "카메라", style: .default){(action) in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
    
        present(alert, animated: true, completion: nil)

    }//showAlert
    
    // 카메라 권한 -----
    func checkCameraPermission(){
        
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {

            } else {

            }
        })
        
    }// checkCameraPermission
    
    // 카메라 열기 -----
    func openCamera(){
        
        self.photo.sourceType = .camera
        self.present(self.photo, animated: false, completion: nil)
        
    }//openCamera
    
    // 앨범 열기 -----
    func openPhoto(){
        
        DispatchQueue.main.async {
            self.photo.sourceType = .photoLibrary   //앨범 지정 실시
            self.photo.allowsEditing = false    // 편집 허용 X
            self.present(self.photo, animated: false, completion: nil)
        }
        
    }//openphoto
    
    // db에 정보 저장 -----
    func dbInsert(){
        
        // DB 인스턴스 만들기
        let storeDB = StoreDB()
        
        let tag = myTag
        guard let name = tfTitle.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let address = lblAddress.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let content = tvContent.text?.trimmingCharacters(in: .whitespaces) else { return }
        var image : UIImage!
        var data : NSData!
        var imageName : String!
        
        if imageData != nil {
            image = UIImage(data: imageData! as Data)
            data = image.pngData()! as NSData
            imageName = "img"
            
        }else{
            
            // 사용자가 사진을 선택하지 않으면 default 이미지로 넣기
            for category in categories {
                
                if myTag == category{
                    image = UIImage(named: category + ".png")
                    imageName = category + ".png"
                    
                }
            }
            
            data = image.pngData()! as NSData
        }
        
        let result = storeDB.insertDB(name: name, address: address, data: data, content: content, category: tag, imageName: imageName)
        
        if result {
            let resultAlert = UIAlertController(title: "완료", message: "입력이 되었습니다.", preferredStyle: .alert)

            let onAction = UIAlertAction(title: "OK", style: .default)
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true)
            
        } else {
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default)
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true)
        }
        
    }//dbInsert
    
    @IBAction func tfTitleEditingDidBegin(_ sender: UITextField) {
        // 키보드 올리면서 화면까지 올리는 옵저버 제거
        notiCenter.removeObserver(self)
    }
    
    // textview 디자인 함수들 -----
    // 1. textview에 입력된 글이 없을 시 placeholder를 띄운다.
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if tvContent.text.isEmpty{
            tvContent.text = "리뷰를 작성하세요."
            tvContent.textColor = UIColor.systemGray4
        }
        
    }//textViewDidEndEditing
    
    // 2. 사용자가 입력을 시작한 경우 placeholder를 비운다.
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if tvContent.textColor == UIColor.systemGray4{
            tvContent.text = nil
            tvContent.textColor = UIColor.secondaryLabel
        }
        
        // 옵저버 등록 - textview 클릭시 키보드만큼 화면이 올라가도록
        notiCenter.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        notiCenter.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }//textViewDidBeginEditing
    
    // textview 글자 수 제한 -----
    //textview 글자 수 제한 감지
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let currentText = tvContent.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            return updatedText.count <= maxCharacters
    }
    
    //textview 글자 수 카운트
    func textViewDidChange(_ textView: UITextView) {
        //placeholderLabel.isHidden = !textView.text.isEmpty
        let currentCount = tvContent.text.count
        let remainingCount = maxCharacters - currentCount
        countLabel.text = "\(remainingCount)/60"
    }
    
    // 완료 버튼 클릭 시 뷰 초기화
    func initPage(){
        
        tvContent.resignFirstResponder()
        
        // 뷰 초기화
        tfTitle.text = ""
        imageData = nil
        imageView.image = UIImage(named: "기타.png")
        tvContent.text = "리뷰를 작성하세요."
        tvContent.textColor = UIColor.systemGray4
        lblAddress.text = " + 버튼을 눌러 위치를 추가하세요."
        lblAddress.textColor = UIColor.lightGray
        
        //글자 수 제한 countlabel 초기 설정
        countLabel.text = "\(maxCharacters)/60"
        
        // 태그 초기화
        myTag = "기타"
        radioButtons[0].isSelected = false
        radioButtons[1].isSelected = false
        radioButtons[2].isSelected = false
        radioButtons[3].isSelected = false
        radioButtons[4].isSelected = false
        radioButtons[5].isSelected = false
        radioButtons[6].isSelected = false
        
        // 메세지 초기화
        Message.address = ""
                
        // 앨범 컨트롤러 딜리게이트 지정
//        self.photo.delegate = self

    }

}// End

// ----------------extension----------------
extension AddViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: [사진, 비디오 선택을 했을 때 호출되는 메소드]
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.originalImage]{
            
            // [앨범에서 선택한 사진 정보 확인]
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
    
}// extension
