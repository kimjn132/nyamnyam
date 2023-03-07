//
//  AddViewController.swift
//  MyWish
//
//  Created by 예띤 on 2023/02/09.
//

import UIKit
import SQLite3
import AVFoundation
import Photos

class WishAddViewController: UIViewController {
    
    @IBOutlet weak var lbltitle: UITextField!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet var tagButtons: [UIButton]!
    
    var db:OpaquePointer?
    
    let categories = ["한식", "중식", "양식", "일식", "분식", "카페", "기타"]
    
    var indexOfBtns: Int? = 0
    
    let ls = ImageInsert()
    
    // sgDetail을 통해 넘겨받은 값
    var sgclicked:Bool = false
    var sgId:Int?
    var sgTitle:String?
    var sgImage:Data?
    var sgTag:String?
    var sgImageName:String?

    var imageData : NSData? = nil
    let photo = UIImagePickerController() // 앨범 이동
    
    var myTag:String = "한식"
//    var defaultImage:String = "한식.png"
//    var imageName:String = "한식.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // sgDetail로 화면 넘어온 경우
        if sgclicked == true {
            lbltitle.text = sgTitle
            lblAddress.text = Message.wishaddress
            imgImage.image = UIImage(data: sgImage!)
            myTag = sgTag!
            
            if sgTag == "한식"{
                tagButtons[0].isSelected = true
            }else if sgTag == "중식"{
                tagButtons[1].isSelected = true
            }else if sgTag == "양식"{
                tagButtons[2].isSelected = true
            }else if sgTag == "일식"{
                tagButtons[3].isSelected = true
            }else if sgTag == "분식"{
                tagButtons[4].isSelected = true
            }else if sgTag == "카페"{
                tagButtons[5].isSelected = true
            }else{
                tagButtons[6].isSelected = true
            }
        }else{ // + barbutton으로 화면 넘어온 경우
            imgImage.image = UIImage(named: "한식.png")
            tagButtons[0].isSelected = true
        }
        
        self.photo.delegate = self
    } // viewDidLoad
    
    
    //키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self == java의 this
        self.view.endEditing(true)
    }
    
    @objc
    private func handleButton(_ sender: UIButton) {
        let nextVC = KakaoZipCodeVC()
        present(nextVC, animated: true)
    }
    
    
    @IBAction func btnCamera(_ sender: UIButton) {
        showAlert()
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
    
    @IBAction func btnAddress(_ sender: UIButton) {
        let nextVC = WishKakaoZipCodeVC()
        nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(nextVC, animated: true)
    }
    
    // Tag 버튼 중 하나 선택
    @IBAction func btnSelectTag(_ sender: UIButton) {
        
        if indexOfBtns != nil{
            
            if !sender.isSelected {
                for unselectIndex in tagButtons.indices {
                    tagButtons[unselectIndex].isSelected = false
                }
                sender.isSelected = true
                indexOfBtns = tagButtons.firstIndex(of: sender)
            } else {
                sender.isSelected = false
                indexOfBtns = nil
            }
        } else {
            sender.isSelected = true
            indexOfBtns = tagButtons.firstIndex(of: sender)
        }
        
        if sgclicked{
            
            if indexOfBtns == 0{
                myTag = "한식"
            }else if indexOfBtns == 1{
                myTag = "중식"
            }else if indexOfBtns == 2{
                myTag = "양식"
            }else if indexOfBtns == 3{
                myTag = "일식"
            }else if indexOfBtns == 4{
                myTag = "분식"
            }else if indexOfBtns == 5{
                myTag = "카페"
            }else {
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
            
            if ((imgImage.image == nil)
                || (imgImage.image == UIImage(named: "카페.png"))
                || (imgImage.image == UIImage(named: "한식.png"))
                || (imgImage.image == UIImage(named: "양식.png"))
                || (imgImage.image == UIImage(named: "일식.png"))
                || (imgImage.image == UIImage(named: "중식.png"))
                || (imgImage.image == UIImage(named: "분식.png"))
                || (imgImage.image == UIImage(named: "기타.png"))
                || categories.contains(sgImageName!.components(separatedBy: ".")[0])){
                
                if myTag == "카페" && imageData == nil{
                    
                    imgImage.image = UIImage(named: "카페.png")
                }
                if myTag == "한식" && imageData == nil{
                    
                    imgImage.image = UIImage(named: "한식.png")
                }
                if myTag == "양식" && imageData == nil{
                    
                    imgImage.image = UIImage(named: "양식.png")
                }
                if myTag == "일식" && imageData == nil{
                    
                    imgImage.image = UIImage(named: "일식.png")
                }
                if myTag == "중식" && imageData == nil{
                    
                    imgImage.image = UIImage(named: "중식.png")
                }
                if myTag == "분식" && imageData == nil{
                    
                    imgImage.image = UIImage(named: "분식.png")
                }
                if myTag == "기타" && imageData == nil{
                    
                    imgImage.image = UIImage(named: "기타.png")
                }
                
            }
            
//            sgImageName = ""
        }else{
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
            if ((imgImage.image == nil)
                || (imgImage.image == UIImage(named: "카페.png"))
                || (imgImage.image == UIImage(named: "한식.png"))
                || (imgImage.image == UIImage(named: "양식.png"))
                || (imgImage.image == UIImage(named: "일식.png"))
                || (imgImage.image == UIImage(named: "중식.png"))
                || (imgImage.image == UIImage(named: "분식.png"))
                || (imgImage.image == UIImage(named: "기타.png"))) {
                
                for category in categories {
                    if myTag == category{
                        imgImage.image = UIImage(named: category + ".png")
                    }
                }
                
            }
        }

    } // btnSelectTag
    
    @IBAction func btnDone(_ sender: UIButton) {
        
        if lbltitle.text?.trimmingCharacters(in: .whitespaces) != "" && lblAddress.text?.trimmingCharacters(in: .whitespaces) != "'+'를 눌러 위치를 추가해주세요." && sgclicked == false{
            dbInsert()
        }
        
        if sgclicked {
            dbUpdate()
        }
        
        if lbltitle.text?.trimmingCharacters(in: .whitespaces) == ""{ // 맛집 텍스트필드 미입력시 Alert
            // Alert
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
        
        if lblAddress.text?.trimmingCharacters(in: .whitespaces) == "'+'를 눌러 위치를 추가해주세요."{ // 위치 추가 안하면 Alert
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
    }
    
    // db에 정보 저장
    func dbInsert(){
        let wishDB = WishDB()
        
        let title = lbltitle.text?.trimmingCharacters(in: .whitespaces)
        let address = lblAddress.text?.trimmingCharacters(in: .whitespaces)
        let tag = myTag
        var image : UIImage!
        var data : NSData!
        var dbimageName: String!
        
        if imageData != nil {
            image = UIImage(data: imageData! as Data)
            data = image!.pngData()! as NSData
            dbimageName = "user"
        }else{ // 사용자가 사진을 선택하지 않으면 default 이미지로 넣기
//            image = UIImage(named: defaultImage)
//            data = image!.pngData()! as NSData
            for category in categories {
                if myTag == category{
                    image = UIImage(named: category + ".png")
                    dbimageName = category + ".png"
                }
            }
            
            data = image.pngData()! as NSData
        }
        
        wishDB.delegate = self
        
        let result = wishDB.insertDB(name: title!, address: address!, data: data!, imagename: dbimageName, category: tag)
        
        if result{
            let resultAlert = UIAlertController(title: "완료", message: "입력되었습니다", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }else {
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생되었습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default)
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true)
        }
        
        Message.wishaddress = "'+'를 눌러 위치를 추가해주세요."
    
    }//dbInsert
    
    func dbUpdate(){
        let wishDB = WishDB()
        
        let title = lbltitle.text?.trimmingCharacters(in: .whitespaces)
        let address = lblAddress.text?.trimmingCharacters(in: .whitespaces)
        let tag = myTag
        let wid = sgId!
        var image : UIImage!
        var data : NSData!
        var dbimageName:String!
        
        if categories.contains(sgImageName!.components(separatedBy: ".")[0]){
            
            if imageData == nil{
                for category in categories {
                    if myTag == category{
                        image = UIImage(named: category + ".png")
                        dbimageName = category + ".png"
                    }
                }

                data = image.pngData()! as NSData
                
            }else{
                image = UIImage(data: imageData! as Data)
                data = image!.pngData()! as NSData
                dbimageName = "user"
            }
            
        }else{
            
            if imageData == nil{
                image = UIImage(data: sgImage!)
                data = image!.pngData()! as NSData
                dbimageName = sgImageName
            }else{
                image = UIImage(data: imageData! as Data)
                data = image!.pngData()! as NSData
                dbimageName = "user"
            }
        }
        
        wishDB.delegate = self
        
        let result = wishDB.updateDB(name: title!, address: address!, data: data, imagename: dbimageName, category: tag, id: wid)
        
        if result{
            let resultAlert = UIAlertController(title: "완료", message: "수정되었습니다", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }else {
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생되었습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default)
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true)
        }
        
        Message.wishaddress = "'+'를 눌러 위치를 추가해주세요."
        sgclicked = false
    }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
    
    // ================ view funcs ====================
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
            Message.wishaddress = "'+'를 눌러 위치를 추가해주세요."
            sgclicked = false
        }
    }//viewwillDisappear
    
    // 뷰 종료 상태
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        //뷰 컨트롤러 포그라운드, 백그라운드 상태 체크 해제
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }//viewDiddisappear
    
//     viewWillAppear: 다른 화면에서 다시 올 때 실행된다.
//     kakao api로 가져온 address를 라벨로 띄워준다.
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
//        address label 채워준다.
        
        lblAddress.text = Message.wishaddress

    } // viewWillAppear

    //포그라운드 및 백그라운드 상태 처리 메소드 작성
    @objc func checkForeground(){
    }
    @objc func checkBackground(){
    }
    
    
} // AddViewController

extension WishAddViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: [사진, 비디오 선택을 했을 때 호출되는 메소드]
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.originalImage]{
            
            // [앨범에서 선택한 사진 정보 확인]
//            print("")
//            print("====================================")
//            print("[A_Image >> imagePickerController() :: 앨범에서 선택한 사진 정보 확인 및 사진 표시 실시]")
//            //print("[사진 정보 :: ", info)
//            print("====================================")
//            print("")
            
            // [이미지 뷰에 앨범에서 선택한 사진 표시 실시]
            imgImage.image = img as? UIImage
//            imageName = "user"
            
            // [이미지 데이터에 선택한 이미지 지정 실시]
            imageData = (img as? UIImage)!.jpegData(compressionQuality: 0.8) as NSData? // jpeg 압축 품질 설정
            
        }
        
        // 이미지 피커 닫기
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: [사진, 비디오 선택을 취소했을 때 호출되는 메소드]
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
//        print("")
//        print("===============================")
//        print("[A_Image >> imagePickerControllerDidCancel() :: 사진, 비디오 선택 취소 수행 실시]")
//        print("===============================")
//        print("")
        
        // 이미지 파커 닫기
        self.dismiss(animated: true, completion: nil)
        
    }
    
}// extension
