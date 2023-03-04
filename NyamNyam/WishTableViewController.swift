//
//  TableViewController.swift
//  MyWish
//
//  Created by 예띤 on 2023/02/07.
//

import UIKit
import SQLite3

class WishTableViewController: UITableViewController {
    
    @IBOutlet var tvListView: UITableView!
    var db: OpaquePointer?
    var wishList : [WishList] = []
    var imageData:NSData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvListView.rowHeight = 140
        
        // SQLite 설정하기
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("WishData.sqlite")
        
        // 설정한 것 실행(파일 연결)
        if sqlite3_open(fileURL.path(), &db) != SQLITE_OK{
            //if error 걸리면
            print("Error opening database")
        }
        
        //shared preferences를 주로 사용, 고객들 개인 정보를 서버에 안두고 분산하기
        
        // Table 만들기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS wish (wId INTEGER PRIMARY KEY AUTOINCREMENT, wName TEXT, wAddress TEXT, wImage BLOB, wTag TEXT)", nil, nil, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("Error create table : \(errMsg)")
            return  //에러 나면은 실행 안한다.
        }
        
        // 셀 리소스 파일 가져오기
//        let myTableViewCellNib = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)
//
//        // 셀 리소스 등록
//        self.tableView.register(myTableViewCellNib, forCellReuseIdentifier: "myCell")
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = 120
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    } // viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        readValues()
    }
    
    func readValues(){
        wishList.removeAll()
        
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM wish order by wId desc"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select : \(errMsg)")
            return  //에러 나면은 실행 안한다.
        }
        
        //data 하나씩 불러오기
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let id = sqlite3_column_int(stmt, 0)    //id 값 가져오기
            let wName = String(cString: sqlite3_column_text(stmt, 1))
            let wAddress = String(cString: sqlite3_column_text(stmt, 2))
            let wImage = Data(bytes: sqlite3_column_blob(stmt, 3), count: Int(sqlite3_column_bytes(stmt, 3)))
            let wTag = String(cString: sqlite3_column_text(stmt, 4))
            
            //while문 돌면서 studentList에 담는다
            wishList.append(WishList(wId: Int(id), wName: wName, wAddress: wAddress, wImage: wImage, wTag: wTag))
        }
        
        self.tvListView.reloadData()        // 하단에 numberOfSection , tableView 모두 실행된다.

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wishList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myWishCell", for: indexPath) as! MyTableViewCell

        // Configure the cell...
        cell.myWishTitle.text = wishList[indexPath.row].wName
        cell.myWishAddress.text = wishList[indexPath.row].wAddress
        cell.myWishTag.text = "#\(wishList[indexPath.row].wTag)"
        cell.myWishImage.image = UIImage(data: wishList[indexPath.row].wImage!)
        
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
            let id = wishList[indexPath.row].wId
            deleteAction(id)
            readValues()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // DB에서 삭제
    func deleteAction(_ id: Int){
        
        var stmt: OpaquePointer?
       
        //-1은 한글 때문이다. 한글은 2byte이기 때문에..
        let queryString = "DELETE FROM wish WHERE wId = ?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        
        sqlite3_bind_int(stmt, 1, Int32(id))
        
        sqlite3_step(stmt)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//
