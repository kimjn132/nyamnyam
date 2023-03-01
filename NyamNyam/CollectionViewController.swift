//
//  CollectionViewController.swift
//  SQLite
//
//  Created by Jeong Yun Hyeon on 2023/02/02.
//

import UIKit
import SQLite3

private let reuseIdentifier = "Cell"

class CollectionViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var db: OpaquePointer?
    var storeList: [Store] = []
    
    var imageData : NSData? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

    }
    
    // 추가 입력 새로 불러오는 역할
    override func viewWillAppear(_ animated: Bool) {
        //readValues()
        print("출력")
        selectData()
    }
    
    func selectData(){
        let storeDB = StoreDB()
        storeList.removeAll()
        
        storeDB.delegate = self

        storeDB.queryDB()
        collectionView.reloadData()
        
    }
    

}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return storeList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        
        cell.uiImage?.image = UIImage(data: storeList[indexPath.row].image!)
        
        return cell
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
        self.collectionView.reloadData()
    }
    
  
    
}
