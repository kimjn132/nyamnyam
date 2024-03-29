//
//  storeDB.swift
//  SQLite
//
//  Created by Anna Kim on 2023/02/19.
//

import Foundation

import SQLite3      //  <<<<<<<<<<<<<<

protocol StoreModelProtocol {
    func itemdownloaded(items: [Store])
}

class StoreDB {
    
    var db: OpaquePointer?
    
    // 사용자 작성 내용 리스트 형식으로 담는 변수
    var storeList: [Store] = []
    var delegate: StoreModelProtocol!
    
    
    
    init() {
        // SQLite 설정하기
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("StoreData.sqlite")
        
       
        if let percentEncodedPath = fileURL.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
            if sqlite3_open(percentEncodedPath, &db) != SQLITE_OK {
                
            }
        }
        
        //shared preferences를 주로 사용, 고객들 개인 정보를 서버에 안두고 분산하기
        
        
        // Table 만들기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS store (sid INTEGER PRIMARY KEY AUTOINCREMENT, sName TEXT, sAddress TEXT, sImage BLOB, sContents TEXT, sCategory TEXT, sDate TEXT, sImageName TEXT)", nil, nil, nil) != SQLITE_OK{


            return  //에러 나면은 실행 안한다.
        }
    }//init
    
    
    
    func insertDB(name: String, address: String, data: AnyObject, content: String, category: String, imageName: String) -> Bool {
        
//        let calendar = Calendar(identifier: .gregorian)
//        let timeZone = TimeZone(identifier: "Asia/Seoul")
//        let dateComponents = calendar.dateComponents(in: timeZone!, from: Date())
//        let myDate = calendar.date(from: dateComponents)!

        let writtenDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "yyyy.MM.dd. E요일"

        let sDate = dateFormatter.string(from: writtenDate)
        
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "INSERT INTO store (sName, sAddress, sImage, sContents, sCategory, sDate, sImageName) VALUES (?,?,?,?,?,?,?)"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, address, -1, SQLITE_TRANSIENT)
        sqlite3_bind_blob(stmt, 3, data.bytes, Int32(Int64(data.length)), SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 4, content, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 5, category, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 6, sDate, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 7, imageName, -1, SQLITE_TRANSIENT)
            
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            return false
        }
        
    }//insertDB
    
    
    
    func queryDB() {
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM store order by sDate DESC"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
           // let errMsg = String(cString: sqlite3_errmsg(db)!)
            
            return  //에러 나면은 실행 안한다.
        }
        
        //data 하나씩 불러오기
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)    //id 값 가져오기
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let address = String(cString: sqlite3_column_text(stmt, 2))
            let image = Data(bytes: sqlite3_column_blob(stmt, 3), count: Int(sqlite3_column_bytes(stmt, 3)))
            let content = String(cString: sqlite3_column_text(stmt, 4))
            let category = String(cString: sqlite3_column_text(stmt, 5))
            let date = String(cString: sqlite3_column_text(stmt, 6))
            let imageName = String(cString: sqlite3_column_text(stmt, 7))

            //while문 돌면서 studentList에 담는다
            // image는 Data 타입으로 보내줌
            storeList.append(Store(id: Int(id), name: name, address: address, image: image, contents: content, category: category, date: date, imageName: imageName))

        }

        self.delegate.itemdownloaded(items: storeList)     // 하단에 numberOfSection , tableView 모두 실행된다.

        
    }//queryDB
        
    
    
    
    func updateDB(name: String, address: String, data: AnyObject, content: String, category: String, id: Int, imageName: String) -> Bool {
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "UPDATE store SET sName=?, sAddress=?, sImage=?, sContents=?, sCategory=?, sImageName=? where sid=?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, address, -1, SQLITE_TRANSIENT)
        sqlite3_bind_blob(stmt, 3, data.bytes, Int32(Int64(data.length)), SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 4, content, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 5, category, -1, SQLITE_TRANSIENT)
        
        sqlite3_bind_text(stmt, 6, imageName, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 7, Int32(id))
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            return false
        }
    }//updateDB
    
    
    
    
    func deleteAction(id: Int) -> Bool {
        
        var stmt: OpaquePointer?
        
        //-1은 한글 때문이다. 한글은 2byte이기 때문에..
        let queryString = "DELETE FROM store WHERE sid = ?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        
        sqlite3_bind_int(stmt, 1, Int32(id))
        
        //completion() // call the completion closure after the deletion is done
        
                if sqlite3_step(stmt) == SQLITE_DONE {
                    return true
                } else {
                    return false
                }
    }
    

    
    
    
}
