//
//  DBHelper.swift
//  ClassSample
//
//  Created by Tran Thanh Trung on 19/01/2022.
//

import Foundation
import SQLite3
import UIKit

class DBHelper {
    var db:OpaquePointer?
    let dbPath: String = "myDb.sqlite"
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    // ham khoi tao database
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    // khởi tạo Table trong database
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY,name TEXT,age INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    // Hàm thêm và add dữ liệu
    func insert(id: Int, name: String, age: Int, yearOfBirth: Int, math: Double, physic: Double, science: Double, address: String) {
        let students = read()
        for p in students {
            if p.id == id {
                return
            }
        }
        let insertStatementString = "INSERT INTO student (Id, name, age) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 0, Int32(id))
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, Int32(age))
            sqlite3_bind_int(insertStatement, 3, Int32(yearOfBirth))
            sqlite3_bind_int(insertStatement, 4, Int32(Double(math)))
            sqlite3_bind_int(insertStatement, 5, Int32(Double(physic)))
            sqlite3_bind_int(insertStatement, 6, Int32(Double(science)))
            sqlite3_bind_text(insertStatement, 7, (address as NSString).utf8String, -1, nil)

            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    // Hàm lấy ra toàn bộ danh sách data da them
    func read() -> [Student] {
        let queryStatementString = "SELECT * FROM student"
        var queryStatement: OpaquePointer? = nil
        var psns : [Student] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let age = sqlite3_column_int(queryStatement, 2)
                let yearOfBirth = sqlite3_column_int(queryStatement, 3)
                let math = sqlite3_column_double(queryStatement, 4)
                let physic = sqlite3_column_double(queryStatement, 5)
                let science = sqlite3_column_double(queryStatement, 6)
                let address = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))

                psns.append(Student(name: name, age: Int(age), yearOfBirth: Int(yearOfBirth), math: Double(math), physic: Double(physic), science: Double(science), address: address))
                print("Query Result:")
                print("\(id) | \(name) | \(age) | \(yearOfBirth) | \(math) | \(physic) | \(science) | \(address)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    // Hàm xoá một giá trị trong dabase
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM student WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    // hàm update một giá trị trong databse
    func query() {
        var queryStatement: OpaquePointer?
        let queryStatementString = "SELECT * FROM Contact;"
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let age = sqlite3_column_int(queryStatement, 1)
                let yearOfBirth = sqlite3_column_int(queryStatement, 2)
                let math = sqlite3_column_double(queryStatement, 3)
                let physic = sqlite3_column_double(queryStatement, 4)
                let science = sqlite3_column_double(queryStatement, 5)
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 6) else {
                    print("Query result is nil")
                    return
                }
                let name = String(cString: queryResultCol1)
                let address = String(cString: queryResultCol1)
                
                print("\nQuery Result:")
                print("\(id) | \(name) | \(age) | \(yearOfBirth) | \(math) | \(physic) | \(science) | \(address)")
            } else {
                print("\nQuery returned no results.")
            }
        } else {
            
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        
        sqlite3_finalize(queryStatement)
    }
    
}
