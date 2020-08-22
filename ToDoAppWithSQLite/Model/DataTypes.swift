//
//  DataTypes.swift
//  ToDoAppWithSQLite
//
//  Created by Trần Huy on 8/20/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation

struct Category {
    var name: String?
    var colour: String?
    var categoryTd: Int64?
    
    init(categoryId: Int64? ,name: String?, colour: String?) {
        self.categoryTd = categoryId
        self.name = name
        self.colour = colour
    }
}

struct Item {
    var itemId: Int64?
    var title: String?
    var done: Bool?
    var dateCreated: Date?
    var dateCompleted: Date?
    var dateDue: Date?
    var category: Category?
    var categoryId: Int64? {
        didSet{
            if let c = try? CategoryBridge.retrieve(id: categoryId!){
                category = c
            }
        }
    }
    
    init(itemId: Int64?, title: String?, done: Bool?, dateCreated: Date?, dateCompleted: Date?, dateDue: Date?, categoryId: Int64?) {
        self.itemId = itemId
        self.title = title
        self.done = done
        self.dateCreated = dateCreated
        self.dateCompleted = dateCompleted
        self.dateDue = dateDue
        
        
        if let id = self.categoryId {
            if let c = try? CategoryBridge.retrieve(id: id) {
                category = c
            }
        }
    }
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        df.timeStyle = .none
        df.dateStyle = .long
        df.doesRelativeDateFormatting = true
        return df
    }()
    
    func detailText(for item: Item) -> String {
        if let completedDate = item.dateCompleted {
        // completed
            return "Completed \(Item.dateFormatter.string(from: completedDate))"
        } else if let due = item.dateDue {
            // not completed, has due date
            
            return "Due \(Item.dateFormatter.string(from: due))"
        } else {
            // not completed, no due date
            return "No due date"
        }
    }
    
}

struct CategoryBridge {
    static func save(category: inout Category) throws {
        let categoryData = toCategoryData(category: category)
        let id = try CategoryDataHelper.insert(item: categoryData)
        category.categoryTd = id
    }
    
    static func toCategoryData(category: Category) -> CategoryData {
        return CategoryData(categoryId: category.categoryTd,
                            name: category.name,
                            colour: category.colour
        )
        
    }
    
    static func retrieve(id: Int64) throws -> Category? {
        if let c = try CategoryDataHelper.find(with: id) {
            return toCategory(categoryData: c)
        }
         return nil
    }
    
    static func toCategory(categoryData: CategoryData) -> Category {
        return Category(categoryId: categoryData.categoryId, name: categoryData.name, colour: categoryData.colour)
    }
}

struct ItemBridge {
    static func save (item: inout Item) throws {
        let itemData = toItemData(item: item)
        let id = try ItemDataHelper.insert(item: itemData)
        item.itemId = id
    }
    
    static func delete(item: Item) throws {
        let itemData = toItemData(item: item)
        try ItemDataHelper.delete(item: itemData)
    }
    static func retrieve(id: Int64) throws -> Item? {
        if let i = try ItemDataHelper.findWithId(id: id) {
            return toItem(itemData: i)
        }
        return nil
    }
    static func toItemData(item: Item) -> ItemData {
        return ItemData(itemId: item.itemId,
                        title: item.title,
                        done: item.done,
                        dateCreated: item.dateCreated,
                        dateCompleted: item.dateCompleted,
                        dateDue: item.dateDue,
                        categoryId: item.categoryId
        )
    }
    
    static func toItem(itemData: ItemData) -> Item {
        return Item(itemId: itemData.itemId,
                    title: itemData.title,
                    done: itemData.done,
                    dateCreated: itemData.dateCreated,
                    dateCompleted: itemData.dateCompleted,
                    dateDue: itemData.dateDue,
                    categoryId: itemData.categoryId)
    }
    
    
}
