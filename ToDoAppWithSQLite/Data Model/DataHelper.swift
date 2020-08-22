//
//  DataHelper.swift
//  ToDoAppWithSQLite
//
//  Created by Trần Huy on 8/20/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import SQLite

protocol DataHelperProtocol {
    associatedtype T
    static func createTable() throws -> Void
    static func insert(item: T) throws -> Int64
    static func delete(item: T) throws -> Void
    static func queryAll() throws -> [T]?
    
}

class CategoryDataHelper: DataHelperProtocol {
    static let database = DatabaseManager.shared.connection
    static let shared = CategoryDataHelper()
    static let tblCategory = Table("tblCategory")

    static let name = Expression<String>("name")
    static let colour = Expression<String>("colour")
    static let categoryId = Expression<Int64>("categoryId")

    typealias T = CategoryData
    init() {
        
    }

    static func createTable() throws {
        guard let connection = database else {
            throw DataAccessError.Datastore_Connection_Error
        }

        do {
            let _ = try connection.run(tblCategory.create(temporary: false, ifNotExists: true, withoutRowid: false, block: {(t) in
                t.column(categoryId, primaryKey: true)
                t.column(name)
                t.column(colour)
            }))

        } catch _ {

        }
    }

    static func insert(item: CategoryData) throws -> Int64 {
        guard let connection = database else {
            throw DataAccessError.Datastore_Connection_Error
        }

        if (item.name != nil ){
            let insert = tblCategory.insert(self.name <- item.name!,
            self.colour <- item.colour!)
            do {
                
                let insertID = try connection.run(insert)
                guard insertID > 0 else {
                    print("Error")
                    throw DataAccessError.Insert_Error
                }
                print("Success")
                return insertID
            } catch {
                throw DataAccessError.Insert_Error
                print("error")
            }
        }

        
        throw DataAccessError.Nil_In_Data
    }
    static func update(id: Int64, with name: String?) throws -> Bool {
        guard let connection = database else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        
            let query = tblCategory.filter(self.categoryId == id)
            var setter: [SQLite.Setter] = [SQLite.Setter]()
        if name != nil {
            setter.append(self.name <- name!)
        }
        let update = query.update(setter)
        if try database!.run(update) <= 0 {
            return false
        }
        return true
        
    }

    static func delete(item: T) throws {
        guard let connection = database else {
            throw DataAccessError.Datastore_Connection_Error
        }

        if let id = item.categoryId {
            let query = tblCategory.filter(categoryId == id)
            do {
                let tmp = try connection.run(query.delete())
                guard tmp == 1 else {
                    throw DataAccessError.Delete_Error
                }
            } catch {
                throw DataAccessError.Delete_Error
            }
        }
    }

    static func queryAll() throws -> [CategoryData]? {
        guard let connection = database else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()

        let items = try connection.prepare(tblCategory)
        for item in items {
            retArray.append(T(categoryId: item[categoryId],
                                         name: item[name],
                                         colour: item[colour]))

        }
        return retArray
    }

    static func find(with id: Int64) throws -> T? {
        guard let connection = database else {
            throw DataAccessError.Datastore_Connection_Error
        }

        let query = tblCategory.filter(categoryId == id)
        let items = try connection.prepare(query)
        for item in items {
            return CategoryData(categoryId: item[categoryId],
                                name: item[name],
                                colour: item[colour]

            )
        }
        return nil
    }


}

class ItemDataHelper: DataHelperProtocol {
    
    
    static let database = DatabaseManager.shared.connection
    static let shared = ItemDataHelper()
    
    static let tblItem = Table("tblItem")
    
    static var itemId = Expression<Int64>("itemId")
    static let title = Expression<String>("title")
    static var done = Expression<Bool>("done")
    static let dateCreated = Expression<Date>("dateCreated")
    static let dateCompleted = Expression<Date?>("dateCompleted")
    static let dateDue = Expression<Date?>("dateDue")
    
    static let categoryId = Expression<Int64>("categoryId")
    
    typealias T = ItemData

    static func createTable() throws {
        guard let connection = database else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            try connection.run(tblItem.create(temporary: false, ifNotExists: true, withoutRowid: false, block: {(table) in
                table.column(self.itemId, primaryKey: true)
                table.column(self.title)
                table.column(self.done, defaultValue: false)
                table.column(self.dateCreated)
                table.column(self.dateCompleted, defaultValue: nil)
                table.column(self.dateDue)
                table.column(self.categoryId)
            }))
        } catch {
            
        }
    }
    
    static func doneTask(with item: Item) {
        guard let connection = database else {
            return
        }
        
        let query = tblItem.filter(self.itemId == item.itemId! as Int64)
        var setter: [SQLite.Setter] = [SQLite.Setter]()
        var date = Date()
        if item.done == !true {
            setter.append(self.dateCompleted <- date)
            
        } else {
            setter.append(self.dateCompleted <- nil)
        }
        setter.append(self.done <- !item.done!)
        let update = query.update(setter)
        try? connection.run(update)
    }
    
    static func insert(item: ItemData) throws -> Int64 {
        guard let connection = database else {
            throw DataAccessError.Datastore_Connection_Error
            
        }
        if (item.categoryId != nil && item.dateCreated != nil && item.title != nil) {
            let insert = tblItem.insert(self.title <- item.title!,
                                        self.done <- item.done!,
                                        self.dateCreated <- item.dateCreated!,
                                        self.dateCompleted <- item.dateCompleted,
                                        self.dateDue <- item.dateDue,
                                        self.categoryId <- item.categoryId!
              
                                        )
            do {
                let insertId = try connection.run(insert)
                print(insertId)
                guard insertId > 0 else {
                    throw DataAccessError.Insert_Error
                }
                print("Insert Item")
                return insertId
            } catch {
                throw DataAccessError.Insert_Error
            }
        }
        
        throw DataAccessError.Insert_Error
        
    }
    
    static func delete(item: ItemData) throws {
        guard let connection = database else {
           throw DataAccessError.Datastore_Connection_Error
        }
        
        if let id = item.itemId {
            let query = tblItem.filter(self.itemId == id)
            do {
                let deleteRows = try connection.run(query.delete())
                guard deleteRows == 1 else {
                   throw DataAccessError.Delete_Error
                }
            } catch {
                throw DataAccessError.Delete_Error
            }
        }
    }
    static func queryWithSelectedCategory(with selectedCategory: Category) throws -> [Item]? {
        guard let connection = database else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [Item]()
        let query = tblItem.filter(self.categoryId == selectedCategory.categoryTd as! Int64)
        let items = try connection.prepare(query)
        for item in items {
            retArray.append(ItemBridge.toItem(itemData: T(itemId: item[itemId],
                                                          title: item[title],
                                                          done: item[done],
                                                          dateCreated: item[dateCreated],
                                                          dateCompleted:item[dateCompleted],
                                                          dateDue: item[dateDue],
                                                          categoryId: item[categoryId])))
        }
        return retArray
    }
    static func queryAll() throws -> [ItemData]? {
        guard let connection = database else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        var retArray = [ItemData]()
        
        let items = try connection.prepare(tblItem)
        for item in items {
            
            
            retArray.append(T(itemId: item[itemId],
                                     title: item[title],
                                     done: item[done],
                                     dateCreated: item[dateCreated],
                                     dateCompleted:item[dateCompleted],
                                     dateDue: item[dateDue],
                                     categoryId: item[categoryId]
            ))
            
        }
        return retArray
    }
    static func findWithId(id: Int64) throws -> T? {
        guard let connection = database else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = tblItem.filter(self.itemId == id)
        
        
        
        let items = try connection.prepare(query)
        for item in items {
            
            
            return ItemData(itemId: item[itemId],
                                     dateDue: item[dateDue],
                                     dateCreated: item[dateCreated],
                                     dateCompleted: item[dateCompleted],
                                     done: item[done],
                                     title: item[title],
                                     categoryId: item[categoryId]
            )
        }
        return nil
        
    }
    
    
    
    static func findWithTitle(selectedCategoryId: Int64, textInput: String) throws -> [Item]? {
        guard let connection = database else {
           throw DataAccessError.Datastore_Connection_Error
        }
        let filterCondition = (self.categoryId == selectedCategoryId) && (self.title.like("%\(textInput)%"))
        
        var retArray = [Item]()
        
        let query = tblItem.filter(filterCondition)
        let items = try connection.prepare(query)
        for item in items {
            

            retArray.append(ItemBridge.toItem(itemData: ItemData(itemId: item[itemId],
                                     dateDue: item[dateDue],
                                     dateCreated: item[dateCreated],
                                     dateCompleted: item[dateCompleted],
                                     done: item[done],
                                     title: item[title],
                                     categoryId: item[categoryId]
                                     )))
        }
        return retArray
    }
    
}
