//
//  CollectionViewController.swift
//  SQLite
//
//  Created by Jeong Yun Hyeon on 2023/02/02.
//

import UIKit
import SQLite3

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet var cvList: UICollectionView!
    
    var storeList: [Store] = []
    var selectedId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        cvList.delegate = self
        cvList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectData()
    }
    
    func selectData(){
        let storeDB = StoreDB()
        storeList.removeAll()
        storeDB.delegate = self
        storeDB.queryDB()
        cvList.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return storeList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        cell.uiImage?.image = UIImage(data: storeList[indexPath.row].image!)
      
      
        return cell
    }
  
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tabBarController?.selectedIndex = 1
        selectedId = storeList[indexPath.row].id
        performSegue(withIdentifier: "sgTV", sender: AnyObject.self)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgTV" {
            if let vc = segue.destination as? TableViewController {
                vc.selectedId = selectedId
            }
        }
      
    }
    
}

//cell에 대한 (extension) Layout
extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1      //가로 3등분 간격을 1씩 빼준다.
        let size = CGSize(width: width, height: width)
        return size
    }
    
    // 좌우 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    // 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
}

extension CollectionViewController: StoreModelProtocol {
    func itemdownloaded(items: [Store]) {
        storeList = items
        self.cvList.reloadData()
    }
   
}
