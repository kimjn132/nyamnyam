//
//  WishDB.swift
//  NyamNyam
//
//  Created by 예띤 on 2023/03/05.
//

import Foundation

import SQLite3

protocol WishModelProtocol{
    func itemdownloaded(items:[Wish])
}

class WishDB{
    var db : OpaquePointer?
    
    var wishList:[Wish] = []
    var delegate: WishModelProtocol!
    
    init() {
        // SQLite 설정하기
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("WishData.sqlite")
        
        // 설정한 것 실행(파일 연결)
        if let percentEncodedPath = fileURL.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
            if sqlite3_open(percentEncodedPath, &db) != SQLITE_OK {
                //if error 걸리면
                print("Error opening database")
            }
        }
        
        // Table 만들기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS wish (wId INTEGER PRIMARY KEY AUTOINCREMENT, wName TEXT, wAddress TEXT, wImage BLOB, wImageName TEXT, wTag TEXT, wDate TEXT)", nil, nil, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("Error create table : \(errMsg)")
            return  //에러 나면 리턴
        }
    } // init
    
    func insertDB(name: String, address: String, data: AnyObject, imagename:String, category: String) -> Bool {
        
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Seoul")
        let dateComponents = calendar.dateComponents(in: timeZone!, from: Date())
        let myDate = calendar.date(from: dateComponents)!

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let wDate = dateFormatter.string(from: myDate)
        
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "INSERT INTO wish (wName, wAddress, wImage, wImageName, wTag, wDate) VALUES (?,?,?,?,?,?)"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, address, -1, SQLITE_TRANSIENT)
        sqlite3_bind_blob(stmt, 3, data.bytes, Int32(Int64(data.length)), SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 4, imagename, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 5, category, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 6, wDate, -1, SQLITE_TRANSIENT)
            
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            return false
        }
    }//insertDB
    
    func queryDB() {
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM wish order by wId desc"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select : \(errMsg)")
            return  //에러 발생 시 리턴
        }
        
        //data 하나씩 불러오기
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)    //id 값 가져오기
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let address = String(cString: sqlite3_column_text(stmt, 2))
            let image = Data(bytes: sqlite3_column_blob(stmt, 3), count: Int(sqlite3_column_bytes(stmt, 3)))
            let imagename = String(cString: sqlite3_column_text(stmt, 4))
            let category = String(cString: sqlite3_column_text(stmt, 5))
//            let date = String(cString: sqlite3_column_text(stmt, 5))

            //while문 돌면서 List에 담기
            // image는 Data 타입으로 보내줌
            wishList.append(Wish(id: Int(id), name: name, address: address, image: image, imagename: imagename, category: category))

        }

        self.delegate.itemdownloaded(items: wishList)     // 하단에 numberOfSection , tableView 모두 실행된다.
    }//queryDB
    
    func updateDB(name: String, address: String, data: AnyObject, imagename: String, category: String, id: Int) -> Bool {
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "UPDATE wish SET wName = ?, wAddress = ?, wImage = ?, wImageName = ?, wTag = ? WHERE wid = ?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_text(stmt , 1, name, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt , 2, address, -1, SQLITE_TRANSIENT)
        sqlite3_bind_blob(stmt, 3, data.bytes, Int32(Int64(data.length)), SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt , 4, imagename, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt , 5, category, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 6, Int32(id))
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            return false
        }
    }//updateDB
    
    func deleteDB(id: Int) -> Bool {
        
        var stmt: OpaquePointer?
        
        //-1은 한글 때문이다. 한글은 2byte이기 때문에..
        let queryString = "DELETE FROM wish WHERE wid = ?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        
        sqlite3_bind_int(stmt, 1, Int32(id))
        
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            return false
        }
    } // deleteDB
    
} // WishDB
