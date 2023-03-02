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

class AddViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    
    // * 필수 입력 설명하는 라벨들
    @IBOutlet weak var lblImage: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblAddress2: UILabel!
    
    // 한식, 중식, 양식, 분식, 일식, 카페 선택 라디오 버튼
    @IBOutlet var radioButtons: [UIButton]!
    //라디오 버튼 선택 index
    var indexOfBtns: Int?
    
    var db: OpaquePointer?

    let photo = UIImagePickerController()   //앨범 이동
    
//    let ls = ImageInsert()
    
    var myTag = "한식"
    
    var imageData : NSData? = nil   // 서버로 이미지 등록을 하기 위함
    
    override func viewDidLoad() {
        
        print("viewDidLoad")
        
        super.viewDidLoad()
        
        // 뷰 텍스트 초기화
        tfTitle.text = ""
        imageView.image = nil
        tvContent.text = ""
        
        // 뷰 디자인 초기화
        lblAddress.layer.borderColor = UIColor.systemGray4.cgColor
        lblAddress.layer.borderWidth = 0.3
        lblAddress.layer.cornerRadius = 5
        
        tvContent.delegate = self
        tvContent.text = "리뷰를 작성하세요."
        tvContent.textColor = UIColor.lightGray
        tvContent.layer.borderColor = UIColor.systemGray4.cgColor
        tvContent.layer.borderWidth = 0.3
        tvContent.layer.cornerRadius = 5
        
        //DB 연결
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("StoreData.sqlite")
        
        // 설정한 것 실행(파일 연결)
        if sqlite3_open(fileURL.path(), &db) != SQLITE_OK{
            //if error 걸리면
            print("Error opening database")
        }
        
        // 앨범 컨트롤러 딜리게이트 지정
        self.photo.delegate = self
        
    }//viewDidLoad
    
    //키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self == java의 this
        self.view.endEditing(true)
    }
    
    // tfTitle 수정 시작
    @IBAction func tfTitleEditingDidBegin(_ sender: UITextField) {
        tfTitle.layer.borderWidth = 0.5
        tfTitle.layer.cornerRadius = 5
        tfTitle.layer.borderColor = UIColor.systemGray5.cgColor
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

    }//btnChooseCategory
    
    // 이미지 추가 버튼 클릭
    @IBAction func btnImage(_ sender: UIButton) {
        
        // 맛집 이름을 적어주지 않았으면 텍스트 필드 색을 빨갛게
        if (tfTitle.text == "") {
            tfTitle.layer.borderWidth = 0.5
            tfTitle.layer.cornerRadius = 5
            tfTitle.layer.borderColor = UIColor.systemRed.cgColor
        }
        
        // 권한 alert
        showAlert()
        
    }//btnImage
    
    // 완료 버튼
    @IBAction func btnDone(_ sender: UIButton) {
        
        // DB에 정보 insert
        dbInsert()
        
    }//btnDone
    
    // + 버튼 눌렀을 때 kakao api를 불러온다.
    @IBAction func btnAddAddress(_ sender: UIButton) {
        
        let nextVC = KakaoZipCodeVC()
        nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(nextVC, animated: true)
        
    }//btnAddAddress
    
    // ===================================================================================================================================================
    // override funcs ====================================================================================================================================
    
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
        
//        tfTitle.text = ""
//        imageView.image = nil
//        lblAddress.text = ""
//        tvContent.text = ""
        
    }//viewwillDisappear
    
    // 뷰 종료 상태
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        print("viewDidDiappear")
        
        //뷰 컨트롤러 포그라운드, 백그라운드 상태 체크 해제
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        
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
            lblAddress.textColor = UIColor.black
        }
        
        print("view will appear: \(Message.address)")
        
    }

    //포그라운드 및 백그라운드 상태 처리 메소드 작성
    @objc func checkForeground(){
    }
    @objc func checkBackground(){
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // funcs =========================================================================
    // alert
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
            if granted {
                print("Camera: 권한 허용")
            } else {
                print("Camera: 권한 거부")
            }
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
    
    // db에 정보 저장
    func dbInsert(){
        
        // DB 인스턴스 만들기
        let storeDB = StoreDB()
        
        let tag = myTag
        guard let name = tfTitle.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let address = lblAddress.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let content = tvContent.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let image = UIImage(data: imageData! as Data) else { return }
        let data = image.pngData()! as NSData
        
        let result = storeDB.insertDB(name: name, address: address, data: data, content: content, category: tag)
        
        if result {
            let resultAlert = UIAlertController(title: "완료", message: "입력이 되었습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true)
        } else {
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default)
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true)
        }
        
//        var stmt: OpaquePointer?
//        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
//
//        let tag = myTag
//        let name = tfTitle.text?.trimmingCharacters(in: .whitespaces)
//        let address = lblAddress.text?.trimmingCharacters(in: .whitespaces)
//        let content = tvContent.text?.trimmingCharacters(in: .whitespaces)
//        let image = UIImage(data: imageData! as Data)
//        let data = image!.pngData()! as NSData
//
//        //-1은 한글 때문이다. 한글은 2byte이기 때문에..
//        let queryString = "INSERT INTO store (sName, sAddress, sImage, sContents, sCategory) VALUES (?,?,?,?,?)"
//
////        CREATE TABLE IF NOT EXISTS store (sid INTEGER PRIMARY KEY AUTOINCREMENT, sName TEXT, sAddress TEXT, sImage BLOB, sContents TEXT)
//
//        sqlite3_prepare(db, queryString, -1, &stmt, nil)
//
//        sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_text(stmt, 2, address, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_blob(stmt, 3, data.bytes, Int32(Int64(data.length)), SQLITE_TRANSIENT)
//        sqlite3_bind_text(stmt, 4, content, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_text(stmt , 5, tag, -1, SQLITE_TRANSIENT)
//
//        sqlite3_step(stmt)
//
//        let resultAlert = UIAlertController(title: "결과", message: "입력되었습니다", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
//
//        resultAlert.addAction(okAction)
//        present(resultAlert, animated: true)
//
//        print("성공")
//        print(data)

    }//dbInsert

    // textview 디자인 함수들 -----
    // 1. textview에 입력된 글이 없을 시 placeholder를 띄운다.
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if tvContent.text.isEmpty{
            tvContent.text = "리뷰를 작성하세요."
            tvContent.textColor = UIColor.lightGray
        }
        
    }
    
    // 2. 사용자가 입력을 시작한 경우 placeholder를 비운다.
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if tvContent.textColor == UIColor.lightGray{
            tvContent.text = nil
            tvContent.textColor = UIColor.black
        }
        
    }
    

}// End

// ----------------extension----------------
extension AddViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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
            imageView.image = img as? UIImage
            
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

