//
//  TableViewController.swift
//  SQLite
//
//  Created by Anna Kim on 2022/12/30.
//

import UIKit



class TableViewController: UITableViewController {

    
    @IBOutlet var tvListView: UITableView!
    
    
    // 사용자 작성 내용 리스트 형식으로 담는 변수
    var storeList: [Store] = []

    var selectedId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("실행")

    } //viewDidLoad
    
    
    
    // 추가 입력 새로 불러오는 역할
    override func viewWillAppear(_ animated: Bool) {
        //readValues()
        print("출력")
        selectData()
        
        if let selectedId = selectedId,
                let index = storeList.firstIndex(where: { $0.id == selectedId }) {
                let indexPath = IndexPath(row: index, section: 0)
                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
    }
    
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
        // #warning Incomplete implementation, return the number of sections
        return 1
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
        cell.imageLoca?.image = UIImage(named:"loca.png")
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let storeDB = StoreDB()
            let id = storeList[indexPath.row].id
            storeDB.delegate = self
            storeDB.deleteAction(id: id)    // 삭제

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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "sgDetail"{
//            let cell = sender as! UITableViewCell
//            let indexPath = self.tvListView.indexPath(for: cell)
//            let detailView = segue.destination as! DetailViewController
//
//            detailView.receivedId = storeList[indexPath!.row].id
//            detailView.receivedName = storeList[indexPath!.row].name
//            detailView.receivedDept = storeList[indexPath!.row].address
//            detailView.receivedImage = storeList[indexPath!.row].image as NSData?
//            detailView.receivedPhone = storeList[indexPath!.row].contents
//            detailView.receivedCategory = storeList[indexPath!.row].category
//            //>>detailviewcontrolller에서 정의한 property에 데이터 넣어줌
//
//            print("segue to detail")
//
//        }
//    }




}

extension TableViewController: StoreModelProtocol {
    func itemdownloaded(items: [Store]) {
        storeList = items
        self.tvListView.reloadData()
    }
    
  
    
}


