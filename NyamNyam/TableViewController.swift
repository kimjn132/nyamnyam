//
//  TableViewController.swift
//  SQLite
//
//  Created by Anna Kim on 2022/12/30.
//

import UIKit



class TableViewController: UITableViewController {
    
    @IBOutlet var tvListView: UITableView!
    
    
    // db 연결
    var storeList: [Store] = []

    // collection view에서 이미지 클릭하면 해당 id 번호의 table cell이 중앙으로 보이게 함
    var selectedId: Int?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    } //viewDidLoad
    


    // 추가 입력 새로 불러오는 역할
    override func viewWillAppear(_ animated: Bool) {
        // db query()
        selectData()
        
        // Date : 2023-03-04
        // Name : YunHyeon Jeong
        // Desc : collection에서 선택한 값(selectedId) 및 modal dismiss용 button 추가(dismissButton)
        if let selectedId = selectedId,
                let index = storeList.firstIndex(where: { $0.id == selectedId }) {
                let indexPath = IndexPath(row: index, section: 0)
                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }

        let dismissButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
        navigationItem.leftBarButtonItem = dismissButton
        if selectedId == nil {
            dismissButton.isHidden = true
        } else {
            dismissButton.isHidden = false
        }
    }

    
    // Date : 2023-03-04
    // Name : YunHyeon Jeong
    // Desc : NotificationCenter로 Dismiss를 알림
    @IBAction func dismissModal(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("TableViewDidDismiss"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    

    // db에 삭제되거나 수정된 데이터 판영하는 함수
    func selectData(){
        let storeDB = StoreDB()
        storeList.removeAll()
        
        storeDB.delegate = self

        storeDB.queryDB()
        tvListView.reloadData()

    }

   
    // MARK: - Table view data source

    // Table column 수
    override func numberOfSections(in tableView: UITableView) -> Int {
        if storeList.count > 0 {
            tvListView.backgroundView = nil
            return 1
        } else {
            //데이터가 없을 때 보여지는 화면
            let noDataView = UIView(frame: CGRect(x: 0, y: 0, width: tvListView.bounds.size.width, height: tvListView.bounds.size.height))
          
            let noDataImg = UIImageView(frame: CGRect(x: 0, y: 250, width: tvListView.bounds.size.width, height: tvListView.bounds.size.height - 600))
            noDataImg.contentMode = .scaleAspectFit
            noDataImg.image = UIImage(named: "chuloop")
            noDataView.addSubview(noDataImg)
            
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 100, width: tvListView.bounds.size.width, height: tvListView.bounds.size.height))
            noDataLabel.text = "방문했던 맛집이 없어요!"
            noDataLabel.textAlignment = .center
            noDataView.addSubview(noDataLabel)
            
            tvListView.backgroundView = noDataView
            return 0
        }

    }

    
    // Table Row 수(사용자 입력 데이터만큼)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storeList.count
    }

    
    //셀 정의
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell

        
        cell.lblStore.text = storeList[indexPath.row].name
        cell.ImageView?.image = UIImage(data: storeList[indexPath.row].image!)
        cell.lblAddress.text = storeList[indexPath.row].address
        cell.lblCategory.text = storeList[indexPath.row].category
        cell.tvContent.text = storeList[indexPath.row].contents
        cell.lblDate.text = storeList[indexPath.row].date
        
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // cell 스와이프 하면 데이터삭제 됨
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let storeDB = StoreDB()
            let id = storeList[indexPath.row].id
            storeDB.delegate = self

            let result = storeDB.deleteAction(id: id)
            if result {
                let resultAlert = UIAlertController(title: "완료", message: "삭제가 되었습니다.", preferredStyle: .alert)
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
            
            selectData()    //삭제한 후 화면 다시 불러오기

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    
    // 수정 페이지로 데이터 보내기 위함
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
  
        if segue.identifier == "sgDetail"{
                let cell = sender as! UITableViewCell
                let indexPath = self.tvListView.indexPath(for: cell)
                let detailView = segue.destination as! UpdateViewController
                
                detailView.receivedId = storeList[indexPath!.row].id
                detailView.receivedName = storeList[indexPath!.row].name
                detailView.receivedAddress = storeList[indexPath!.row].address
                detailView.receivedImage = storeList[indexPath!.row].image as NSData?
                detailView.receivedContent = storeList[indexPath!.row].contents
                detailView.receivedCategory = storeList[indexPath!.row].category
                detailView.receivedImageName = storeList[indexPath!.row].imageName
                //>>detailviewcontrolller에서 정의한 property에 데이터 넣어줌

            }
            
        }
        
    }// End

//db protocol
extension TableViewController: StoreModelProtocol {
    func itemdownloaded(items: [Store]) {
        storeList = items
        self.tvListView.reloadData()
    }
    
  
    
}


