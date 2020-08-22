////
////  Category.swift
////  ToDoAppWithSQLite
////
////  Created by Trần Huy on 8/18/20.
////  Copyright © 2020 Trần Huy. All rights reserved.
////
//
//import UIKit
//import SQLite
//
//
//
//class CategoryEntity {
//    let database = DatabaseManager.shared.connection
//    static let shared = CategoryEntity()
//    private let tblCategory = Table("tblCategory")
//
//    let name = Expression<String>("name")
//    let colour = Expression<String>("colour")
//    let id = Expression<Int64>("id")
//
//    private init() {
//        do {
//            if let connection = database {
//                try connection.run(tblCategory.create(temporary: false, ifNotExists: true, withoutRowid: false, block: {(table) in
//                    table.column(id, primaryKey: true)
//                    table.column(name)
//                    table.column(colour)
//                }))
//            }
//        } catch {
//
//        }
//    }
//
//    func insert(name: String, colour: String) -> Int64? {
//        do {
//            let insert = tblCategory.insert(self.name <- name,
//                                            self.colour <- colour)
//            let insertID = try database?.run(insert)
//            return insertID
//        } catch {
//            return nil
//        }
//    }
//
//    func update(id: Int64, name: String?) -> Bool {
//        if database == nil {
//            return false
//        }
//        do {
//            let tblFilterCategory = self.tblCategory.filter(self.id == id)
//            var setter: [SQLite.Setter] = [SQLite.Setter]()
//            if name != nil {
//                setter.append(self.name <- name!)
//            }
//
//            let update = tblFilterCategory.update(setter)
//            if try (database?.run(update))! <= 0 {
//                return false
//            }
//            return true
//
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
//
//    }
//
//    func queryAll() -> AnySequence<Row>? {
//        do {
//            return try database?.prepare(self.tblCategory)
//        } catch {
//            return nil
//        }
//    }
//
//    func filter(with name1: String) -> AnySequence<Row>? {
//        let filterCondition = name.like(name1)
//        do {
//            return try database?.prepare(self.tblCategory.filter(filterCondition))
//        } catch {
//            return nil
//        }
//    }
//}
