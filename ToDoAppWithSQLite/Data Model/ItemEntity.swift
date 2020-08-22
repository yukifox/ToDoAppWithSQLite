////
////  Item.swift
////  ToDoAppWithSQLite
////
////  Created by Trần Huy on 8/19/20.
////  Copyright © 2020 Trần Huy. All rights reserved.
////
//
//import Foundation
//import SQLite
//class ItemEntity {
//    private let database = DatabaseManager.shared.connection
//    let shared = ItemEntity()
//    
//    private let tblItem = Table("tblItem")
//    
////    private let id = Expression<Int64>("id")
////    private let title = Expression<String>("title")
////    private var done = Expression<Bool>("done")
////    private let dateCreated = Expression<Date>("dateCreated")
////    private let dateCompleted = Expression<Date>("dateCompleted")
////    private let dateDue1 = Expression<Date?>("dateDue")
//    
////    private let categoryId = Expression<Int64>("categoryId")
//    
//    
//    private init() {
//        //Create table if not exists
//        
//        do {
//            if let connection = database {
//                try connection.run(tblItem.create(temporary: false, ifNotExists: true, withoutRowid: false, block: {(table) in
//                    table.column(self.id, primaryKey: true)
//                    table.column(self.title)
//                    table.column(self.done, defaultValue: false)
//                    table.column(self.dateCreated)
//                    table.column(self.dateCompleted)
//                    table.column(self.dateDue)
////                    table.column(self.categoryId)
//                }))
//            }
//        } catch {
//            
//        }
//        
//    }
//    func insert(title: String, dateCreated: Date, dateDue: Date?) -> Int64? {
//        do {
//            let insert = tblItem.insert(self.title <- title,
//                                        self.dateCreated <- dateCreated,
//                                        self.dateDue <- dateDue
//                                        
//                                        
//                                        )
//            let insertID = try database?.run(insert)
//            return insertID
//        } catch {
//            return nil
//        }
//    }
//    
//    func update(id: Int64, titleE: String?, done: Bool?, dateCompleted: Date?) -> Bool {
//        if database == nil {
//            return false
//        }
//        
//        do {
//            let tblItemFilter = self.tblItem.filter(self.id == id)
//            var setter: [SQLite.Setter] = [SQLite.Setter]()
//            if title != nil {
//                setter.append(self.title <- titleE!)
//            }
//            if done != nil {
//                setter.append(self.done <- done!)
//            }
//            
//            if dateCompleted != nil {
//                setter.append(self.dateCompleted <- dateCompleted!)
//            }
//            
//            let update = tblItemFilter.update(setter)
//            
//            if try (database?.run(update))! <= 0 {
//                return false
//            }
//            return true
//            
//        } catch {
//            return false
//        }
//    }
//    
//    func filter(with title: String, in categoryId: Int64) -> AnySequence<Row>? {
//        let filterCondition = self.title.like("%\(title)%") && (id == categoryId)
//        do {
//            return try database?.prepare(self.tblItem.filter(filterCondition))
//        } catch {
//            return nil
//        }
//    }
//    
//    func query(with categoryId: Int64) -> AnySequence<Row>? {
//        do {
//            let filterCondition = self.categoryId == categoryId
//            return try database?.prepare(self.tblItem.filter(filterCondition))
//        } catch {
//            return nil
//        }
//    }
//    
//    
//    
//    static let dateFormatter: DateFormatter = {
//        let df = DateFormatter()
//        df.dateFormat = "dd/MM/yyyy"
//        df.timeStyle = .none
//        df.dateStyle = .long
//        df.doesRelativeDateFormatting = true
//        return df
//    }()
//    
//    func detailText(for item: Item) -> String {
////        if let completedDate = item.dateCompleted {
////        // completed
////            return "Completed \(Item.dateFormatter.string(from: completedDate))"
////        } else if let due = item.dateDue {
////            // not completed, has due date
////
////            return "Due \(Item.dateFormatter.string(from: due))"
////        } else {
////            // not completed, no due date
////            return "No due date"
////        }
//        return ""
//    }
//    
//    
//    
//}
