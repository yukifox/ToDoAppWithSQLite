//
//  DâtModel.swift
//  ToDoAppWithSQLite
//
//  Created by Trần Huy on 8/20/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import SQLite

typealias CategoryData = (
    categoryId: Int64?,
    name: String?,
    colour: String?
    
)

typealias ItemData = (
    itemId: Int64?,
    title: String?,
    done: Bool?,
    dateCreated: Date?,
    dateCompleted: Date?,
    dateDue: Date?,
    categoryId: Int64?
    
)


