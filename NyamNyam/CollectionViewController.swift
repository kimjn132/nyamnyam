//
//  CollectionViewController.swift
//  SQLite
//
//  Created by Jeong Yun Hyeon on 2023/02/02.
//  Desc : CollectionView를 이용한 사진모음, Cell클릭시 TableView Modal로 나타남

import UIKit
//import SQLite3

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet var cvList: UICollectionView! // CollectionView
    
    var storeList: [Store] = [] // DB
    var selectedId: Int? // Modal에 넘겨줄 ID

    override func viewDidLoad() {
        super.viewDidLoad()

        cvList.delegate = self
        cvList.dataSource = self
        
        // TableView Modal에서 Dismiss 감지
        NotificationCenter.default.addObserver(self, selector: #selector(didDismissTableView), name: NSNotification.Name("TableViewDidDismiss"), object: nil)
    }
    
    // Dismiss 감지시 Data 새로 불러옴
    @objc func didDismissTableView(_ notification: Notification) {
        selectData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectData() // SQLite에서 Data Select
    }
    
    func selectData(){
        let storeDB = StoreDB()
        storeList.removeAll()
        storeDB.delegate = self
        storeDB.queryDB()
        cvList.reloadData()
    }
    
    // 데이터가 없을 시 Label과 ImageView를 보여주고 있으면 Data를 보여줌
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
      if storeList.count > 0 {
          collectionView.backgroundView = nil
          return 1
      } else {
          let noDataView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        
          let noDataImg = UIImageView(frame: CGRect(x: 0, y: 280, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height - 650))
          noDataImg.contentMode = .scaleAspectFit
          noDataImg.image = UIImage(named: "bear")
          noDataView.addSubview(noDataImg)
          
          let noDataLabel = UILabel(frame: CGRect(x: 0, y: 100, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
          noDataLabel.text = "저장된 사진이 없어요!"
          noDataLabel.textAlignment = .center
          noDataView.addSubview(noDataLabel)
          
          collectionView.backgroundView = noDataView
          return 0
      }
  }
    
    // 전체 CollectionView Cell의 개수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeList.count
    }
    
    // DB의 image를 cell에 연동
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        cell.uiImage?.image = UIImage(data: storeList[indexPath.row].image!)
      
      
        return cell
    }
    
    // cell 클릭 허용
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // cell 클릭 시 selectedId를 클릭된 cell id로 저장
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tabBarController?.selectedIndex = 1
        selectedId = storeList[indexPath.row].id
        performSegue(withIdentifier: "sgTV", sender: AnyObject.self)
    }
  
    // segue(sgTV)를 통해 Data를 넘겨줌
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "sgTV" {
          // 이동할 뷰 컨트롤러가 Navigation Controller인 경우
          if let navController = segue.destination as? UINavigationController,
             let tableViewController = navController.topViewController as? TableViewController {
              tableViewController.selectedId = selectedId
          // 이동할 뷰 컨트롤러가 TableViewController인 경우
          } else if let tableViewController = segue.destination as? TableViewController {
              tableViewController.selectedId = selectedId
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
      return 0.5
    }
    
    // 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 1
    }
    
}

// DB
extension CollectionViewController: StoreModelProtocol {
    func itemdownloaded(items: [Store]) {
        storeList = items
        self.cvList.reloadData()
    }
   
}
