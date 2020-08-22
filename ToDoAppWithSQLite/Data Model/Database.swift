//
//  Database.swift
//  ToDoAppWithSQLite
//
//  Created by Trần Huy on 8/18/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import SQLite

enum DataAccessError: Error {
    case Datastore_Connection_Error
    case Insert_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
}

class DatabaseManager {
    static let shared = DatabaseManager()
    public let connection: Connection?
    public let databaseFileName = "sqliteTodoApp.sqlite3"
    private init() {
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as! String
        do {
            connection = try Connection("\(dbPath)/(databaseFileName)")
            print(dbPath)
        } catch {
            connection = nil
            print("Cannot connect to Database, error is \(error.localizedDescription)")
        }
    }
    
    func createTables() throws {
        do {
            try CategoryDataHelper.createTable()
            try ItemDataHelper.createTable()
        } catch {
            
        }
    }
}
