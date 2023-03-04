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
    
    var indexOfBtns: Int? = 0
    
    let ls = ImageInsert()
    
//    let lbAddress = UILabel()
//    let btnPostcode = UIButton(type: .system)
    var imageData : NSData? = nil
    let photo = UIImagePickerController() // 앨범 이동
    
    var myTag = "한식"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("WishData.sqlite") // create true해놓으면 앱 뜰때마다 바뀜 in의 마스크는 보안용
        
        // file만든걸 실행시켜야지 (exec)
        sqlite3_open(fileURL.path(), &db) // open한다
        
        // 초기화
        imgImage.image = UIImage(named: "sample.jpeg")
        tagButtons[0].isSelected = true
        
        self.photo.delegate = self
    }
    
    
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
        }else{
            myTag = "카페"
        }
        
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        
        if lbltitle.text?.trimmingCharacters(in: .whitespaces) != "" && lblAddress.text?.trimmingCharacters(in: .whitespaces) != "'+'를 눌러 위치를 추가해주세요."{
            dbInsert()
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
        var stmt: OpaquePointer?
        // 한글처리 !! <<<
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self) // -1부터 시작지점을 해주면 2글자씩 읽음(한글)
        
        let title = lbltitle.text?.trimmingCharacters(in: .whitespaces)
        let address = lblAddress.text?.trimmingCharacters(in: .whitespaces)
        let tag = myTag
        var image : UIImage!
        var data : NSData!
        
        if imageData != nil {
            image = UIImage(data: imageData! as Data)
            data = image!.pngData()! as NSData
        }else{ // 사용자가 사진을 선택하지 않으면 default 이미지로 넣기
            image = UIImage(named: "sample.jpeg")
            data = image!.pngData()! as NSData
        }
        
        let queryString = "INSERT INTO wish (wName, wAddress, wImage, wTag) VALUES (?,?,?,?)"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        // ?에 data넣기
        sqlite3_bind_text(stmt , 1, title, -1, SQLITE_TRANSIENT)// 넣을 데이터가 다 text라 bint_text임 아닐경우에는 찾아봐야함
        sqlite3_bind_text(stmt , 2, address, -1, SQLITE_TRANSIENT)
        sqlite3_bind_blob(stmt, 3, data.bytes, Int32(Int64(data.length)), SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt , 4, tag, -1, SQLITE_TRANSIENT)
        
        sqlite3_step(stmt)
        
        let resultAlert = UIAlertController(title: "결과", message: "입력 되었습니다", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네, 알겠습니다", style: .default, handler: {ACTION in
            self.navigationController?.popViewController(animated: true)
        })
        
        resultAlert.addAction(okAction)
        present(resultAlert, animated: true)
        
        Message.wishaddress = "'+'를 눌러 위치를 추가해주세요."
        Message.address = ""
    
    }//dbInsert
        
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
        print("viewWillDisappear")
        Message.wishaddress = "'+'를 눌러 위치를 추가해주세요."
        
    }//viewwillDisappear
    
    // 뷰 종료 상태
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        print("viewDidDiappear")
        
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
        print("view will appear: \(Message.wishaddress)")

    }

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
            print("")
            print("====================================")
            print("[A_Image >> imagePickerController() :: 앨범에서 선택한 사진 정보 확인 및 사진 표시 실시]")
            //print("[사진 정보 :: ", info)
            print("====================================")
            print("")
            
            // [이미지 뷰에 앨범에서 선택한 사진 표시 실시]
            imgImage.image = img as? UIImage
            
            // [이미지 데이터에 선택한 이미지 지정 실시]
            imageData = (img as? UIImage)!.jpegData(compressionQuality: 0.8) as NSData? // jpeg 압축 품질 설정
            
        }
        
        // 이미지 피커 닫기
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: [사진, 비디오 선택을 취소했을 때 호출되는 메소드]
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("")
        print("===============================")
        print("[A_Image >> imagePickerControllerDidCancel() :: 사진, 비디오 선택 취소 수행 실시]")
        print("===============================")
        print("")
        
        // 이미지 파커 닫기
        self.dismiss(animated: true, completion: nil)
        
    }
    
}// extension
