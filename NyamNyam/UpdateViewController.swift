//
//  UpdateViewController.swift
//  NyamNyam
//
//  Created by Anna Kim on 2023/03/05.
//

import UIKit
import Photos


class UpdateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var lblAddress: UITextField!
    
    //글자 수 제한 - 60자
    @IBOutlet weak var countLabel: UILabel!
    let maxCharacters = 60
    
    //DB 연결
    var storeList: [Store] = []
    
    // 한식, 중식, 양식, 분식, 일식, 카페 선택 라디오 버튼
    let categories = ["한식", "중식", "양식", "일식", "분식", "카페", "기타"]
    @IBOutlet var radioButtons: [UIButton]!
    var indexOfBtns: Int? = 0   //라디오 버튼 선택 index, 0 초기값만 있으면 중복 체크 안됨!
    
    //이미지 수정
    let photo = UIImagePickerController()   //앨범 이동
    var imageData : NSData? = nil   // 서버로 이미지 등록을 하기 위함
    
    //기본 디폴트
    var myTag = "기타"
    
    // 키보드 올라가는 것 감지
    let notiCenter = NotificationCenter.default
    
    
    // 수정할 내용 불러오기 위한 변수 선언
    var sgclicked:Bool = false
    var receivedId = 0
    var receivedName = ""
    var receivedAddress = ""
    var receivedImage: NSData?
    var receivedContent = ""
    var receivedCategory = ""
    var receivedImageName = ""
    
    
    // 주소 업데이트 반영을 위해 설정해주는 if문 값
    var count1 = 0
    var count2 = 0
    
    
    let kakaoZipCodeVC = KakaoZipCodeVC()
    var newAddress: AddressModel?
    

    

    
    // ================== LifeCycle Method ==================
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textViewDidEndEditing(tvContent)
        textViewDidBeginEditing(tvContent, lblAddress)
        
        if sgclicked == true {   // TableView에서 클릭할 때
            
            
            
            // 뷰 텍스트 첫 화면(수정 전 데이터)
            tfTitle.text = String(receivedName)
            imageView.image = UIImage(data: receivedImage! as Data)
            tvContent.text = String(receivedContent)
            myTag = receivedCategory
            lblAddress.text = String(receivedAddress)
            
            switch receivedCategory {
            case "한식":
                radioButtons[0].isSelected = true
            case "중식":
                radioButtons[1].isSelected = true
            case "양식":
                radioButtons[2].isSelected = true
            case "일식":
                radioButtons[3].isSelected = true
            case "분식":
                radioButtons[4].isSelected = true
            case "카페":
                radioButtons[5].isSelected = true
            default:
                radioButtons[6].isSelected = true
            }
            
            
            
        }else if sgclicked == false { // + barbutton으로 화면 넘어온 경우
            imageView.image = UIImage(named: "한식.png")
            radioButtons[0].isSelected = true
            lblAddress.text = ""
        }
        
        
        //글자 수 제한 countlabel 초기 설정(수정 전 입력한 글자 수 만큼 보여주기)
        let currentCount = String(receivedContent).count
        let remainingCount = maxCharacters - currentCount
        countLabel.text = "\(remainingCount)/60"
        
        
        // textView delegate
        tvContent.delegate = self
        
        // 앨범 컨트롤러 딜리게이트 지정
        photo.delegate = self
        
        
        
        
    }//viewDidLoad
    
    // kakao api로 가져온 address를 라벨로 띄워준다.
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)


        
        count2 += 1
        
        
        if count2 == 1 {
            lblAddress.text = String(receivedAddress)
        } else {
            lblAddress.text = newAddress?.address
        }
        
        
        if newAddress?.address == nil {
            count2 = 1
        }
        
        



    }
    
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
        
        if self.isMovingFromParent{
            
            sgclicked = false
        }


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
    

    
    // ================== LifeCycle Method END ==================
    
    
    
    //키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self == java의 this
        self.view.endEditing(true)
    }
    
    
    
    
    
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
        
        switch indexOfBtns {
        case 0:
            myTag = "한식"
        case 1:
            myTag = "중식"
        case 2:
            myTag = "양식"
        case 3:
            myTag = "일식"
        case 4:
            myTag = "분식"
        case 5:
            myTag = "카페"
        default:
            myTag = "기타"
        }
        
        
        // myTag에 선택한 카테고리 버튼 값 넣어주기
        var i = 0
        for category in categories {
            if indexOfBtns == i{
                myTag = category
            }
            i += 1
        }
        
        
        // 사용자가 직접 사진을 안 넣으면 대신 넣을 디폴트 이미지(카테고리에 따라 다른 디폴트 이미지 제공 to 사용자)
        if ((imageView.image == nil)
            || (imageView.image == UIImage(named: "카페.png"))
            || (imageView.image == UIImage(named: "한식.png"))
            || (imageView.image == UIImage(named: "양식.png"))
            || (imageView.image == UIImage(named: "일식.png"))
            || (imageView.image == UIImage(named: "중식.png"))
            || (imageView.image == UIImage(named: "분식.png"))
            || (imageView.image == UIImage(named: "기타.png"))
            || (receivedImageName == "카페.png")
            || (receivedImageName == "한식.png")
            || (receivedImageName == "양식.png")
            || (receivedImageName == "일식.png")
            || (receivedImageName == "중식.png")
            || (receivedImageName == "분식.png")
            || (receivedImageName == "기타.png")) {
            //            || categories.contains(receivedImageName.components(separatedBy: ".")[0])){
            
            if myTag == "카페" && imageData == nil {
                
                imageView.image = UIImage(named: "카페.png")
                
            }
            if myTag == "한식" && imageData == nil {
                
                imageView.image = UIImage(named: "한식.png")
            }
            if myTag == "양식" && imageData == nil {
                
                imageView.image = UIImage(named: "양식.png")
            }
            if myTag == "일식" && imageData == nil {
                
                imageView.image = UIImage(named: "일식.png")
            }
            if myTag == "중식" && imageData == nil {
                
                imageView.image = UIImage(named: "중식.png")
            }
            if myTag == "분식" && imageData == nil {
                
                imageView.image = UIImage(named: "분식.png")
            }
            if myTag == "기타" && imageData == nil {
                
                imageView.image = UIImage(named: "기타.png")
            }
            
            receivedImageName = myTag + ".png"
            
        }
        
    }//btnChooseCategory
    
    
    // 이미지 추가 버튼 클릭
    @IBAction func btnImage(_ sender: UIButton) {
        
        // 권한 alert
        showAlert()
        
    }//btnImage
    
    
    // Edit button
    @IBAction func btnDone(_ sender: UIBarButtonItem) {
        
        
        
        if tfTitle.text?.trimmingCharacters(in: .whitespaces) != "" && lblAddress.text?.trimmingCharacters(in: .whitespaces) != "'+'를 눌러 위치를 추가해주세요." &&
            tvContent.text?.trimmingCharacters(in: .whitespaces) != "" &&
            sgclicked == false {
            dbInsert()
            
        }
        if sgclicked {
            // DB에 정보 update
            dbUpdate()
        }
        
        
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
            
        }
        
        if lblAddress.text?.trimmingCharacters(in: .whitespaces) == "+ 버튼을 눌러 위치를 추가하세요."{ // 위치 추가 안하면 Alert
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
        }
        
        if (tvContent.text!.trimmingCharacters(in: .whitespaces).isEmpty) || tvContent.text == "리뷰를 작성하세요."{
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
            
        }
        
    }//btnDone
    
    
    // + 버튼 눌렀을 때 kakao api를 불러온다.
    @IBAction func btnAddAddress(_ sender: UIButton) {
        

        
        let nextVC = KakaoZipCodeVC()
        nextVC.kakaoDelegate = self
        // 이동하기 before 페이지 컨트롤러에서 after 페이지에 미리 navigationController로 감싸준 뒤 이동시켜야 한다.
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
        
    }//btnAddAddress
    



    

    //포그라운드 및 백그라운드 상태 처리 메소드 작성
    @objc func checkForeground(){
    }
    @objc func checkBackground(){
    }
    
    
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
    
    
    // 카메라 권한
    func checkCameraPermission(){
        
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
        })
        
    }// checkCameraPermission
    
    // 카메라 열기
    func openCamera(){
        
        self.photo.sourceType = .camera
        self.present(self.photo, animated: false, completion: nil)
        
    }//openCamera
    
    // 앨범 열기
    func openPhoto(){
        
        DispatchQueue.main.async {
            self.photo.sourceType = .photoLibrary   //앨범 지정 실시
            self.photo.allowsEditing = false    // 편집 허용 X
            self.present(self.photo, animated: false, completion: nil)
        }
        
    }//openphoto
    
    
    
    // db에 정보 수정 반영
    func dbUpdate(){
        
        // DB 인스턴스 만들기
        let storeDB = StoreDB()
        
        let tag = myTag
        guard let name = tfTitle.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let address = lblAddress.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let content = tvContent.text?.trimmingCharacters(in: .whitespaces) else { return }
        var image : UIImage!
        var data : NSData!
        var imageName : String!
        
        
        if categories.contains(receivedImageName.components(separatedBy: ".")[0]){
            
            
            
            if imageData == nil{
                
                for category in categories {
                    
                    if myTag == category{
                        
                        image = UIImage(named: category + ".png")
                        imageName = category + ".png"
                        
                    }
                    
                }
                
                data = image.pngData()! as NSData
                
            }else{
                
                image = UIImage(data: imageData! as Data)
                data = image!.pngData()! as NSData
                imageName = "user"
                
            }
            
        }else{
            
            if imageData == nil{
                
                image = UIImage(data: receivedImage! as Data)
                data = image!.pngData()! as NSData
                imageName = receivedImageName
                
            }else{
                
                image = UIImage(data: imageData! as Data)
                data = image!.pngData()! as NSData
                imageName = "user"
                
            }
        }
        
        
        storeDB.delegate = self
        
        
        let result = storeDB.updateDB(name: name, address: address, data: data, content: content, category: tag, id: receivedId, imageName: imageName)
        
        if result{
            let resultAlert = UIAlertController(title: "결과", message: "수정 되었습니다", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네 알겠습니다.", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }else{
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default)
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true)
        }
        // static 초기화 안 해주면 table 돌아간 후 다른 데이터 수정할 때 이전 데이터 수정한 주소가 똑같이 불러와져서 초기화 시켜줌
        
        
        sgclicked = false
        
    }//dbUpdate
    
    
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
            
            let okAction = UIAlertAction(title: "네 알겠습니다.", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
            
        } else {
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default)
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true)
        }
        
        
        
    }//dbInsert
    
    
    
    
    // textview 디자인 함수들 -----
    // 1. textview에 입력된 글이 없을 시 placeholder를 띄운다.
    func textViewDidEndEditing(_ textView: UITextView) {
        let placeholder = "리뷰를 작성하세요"
        if tvContent.text.isEmpty{
            tvContent.text = placeholder
            tvContent.textColor = UIColor.lightGray
        }else{
            tvContent.text = nil
            tvContent.textColor = UIColor.black
        }
        
    }
    
    // 2. 사용자가 입력을 시작한 경우 placeholder를 비운다.
    func textViewDidBeginEditing(_ textView: UITextView, _ textField: UITextField) {
        
        
        // 옵저버 등록 - textview 클릭시 키보드만큼 화면이 올라가도록
        notiCenter.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        notiCenter.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
}// End

