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
    var wishList : [Wish] = []
    var imageData:NSData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvListView.rowHeight = 140
        
    } // viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        readValues()
    } // viewWillAppear
    
    func readValues(){
        let wishDB = WishDB()
        wishList.removeAll()
        
        wishDB.delegate = self
        
        wishDB.queryDB()
        tvListView.reloadData()

    } // readValues

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if wishList.count > 0 {
            tableView.backgroundView = nil
            return 1
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "'+' 버튼을 눌러 가고 싶은 맛집을 추가해보세요."
//            noDataLabel.textColor = .black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wishList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myWishCell", for: indexPath) as! MyTableViewCell

        // Configure the cell...
        cell.myWishTitle.text = wishList[indexPath.row].name
        cell.myWishAddress.text = wishList[indexPath.row].address
        cell.myWishTag.text = "#\(wishList[indexPath.row].category)"
        cell.myWishImage.image = UIImage(data: wishList[indexPath.row].image!)
        
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
            let wishDB = WishDB()
            let id = wishList[indexPath.row].id
            wishDB.delegate = self
            
            let result = wishDB.deleteDB(id: id)
            if result{
                let resultAlert = UIAlertController(title: "완료", message: "삭제되었습니다.", preferredStyle: .alert)
                let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                    self.navigationController?.popViewController(animated: true)
                })
                
                resultAlert.addAction(onAction)
                present(resultAlert, animated: true)
            } else {
                let resultAlert = UIAlertController(title: "실패", message: "에러가 발생되었습니다.", preferredStyle: .alert)
                let onAction = UIAlertAction(title: "OK", style: .default)
                
                resultAlert.addAction(onAction)
                present(resultAlert, animated: true)
            }
            
            readValues()
            
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        let addViewController = segue.destination as! WishAddViewController
        
        if segue.identifier == "sgDetail"{
            let cell = sender as! MyTableViewCell
            let indexpath = tvListView.indexPath(for: cell)
            addViewController.sgclicked = true
            addViewController.sgId = wishList[indexpath!.row].id
            addViewController.sgTitle = wishList[indexpath!.row].name
            Message.wishaddress = wishList[indexpath!.row].address
            addViewController.sgImage = wishList[indexpath!.row].image
            addViewController.sgTag = wishList[indexpath!.row].category
            
        
        }
        
    }
    

} // WishTableViewController

