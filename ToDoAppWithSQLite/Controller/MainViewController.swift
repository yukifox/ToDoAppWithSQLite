//
//  MainViewController.swift
//  ToDoAppWithSQLite
//
//  Created by Trần Huy on 8/18/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework
import SQLite
class MainViewController: UIViewController, MessageProtocol {
    //MARK: - Properties
    
    let dataStore = DatabaseManager.shared
    
//    let realm = try! Realm()
//    var categories: Results<Category>?
    var categories = [Category]()
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try dataStore.createTables()
        } catch {
            
        }
        loadCategories()
        initView()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        configNavigationView()
    }
    
    //MARK: - Handler
    func initView() {
        view.backgroundColor = .white
//        categories = realm.objects(Category.self)
        
        if categories.isEmpty {
            let message = MessageController(text: "Tap the button to create your first Category", actionTitle: "Create Category", actionHandler: {[weak self] in
                self?.addCategory()
            })
            message.view.frame = self.view.bounds
            
            message.delegate = self
            message.willMove(toParent: self)
            view.addSubview(message.view)
            self.addChild(message)
            message.didMove(toParent: self)
        } else {
            let categoryVC = CategoryView()
            categoryVC.view.frame = self.view.bounds
            categoryVC.willMove(toParent: self)
            view.addSubview(categoryVC.view)
            self.addChild(categoryVC)
            categoryVC.didMove(toParent: self)
            
        }
    }
    
    func configNavigationView() {
           navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
           navigationItem.rightBarButtonItem?.tintColor = UIColor.white
           navigationItem.title = "TodoApp"
           
           navigationController?.navigationBar.barTintColor = UIColor.systemBlue
    }
    
    //MARK: - Selector
    
    @objc func addBtnPressed() {
        addCategory()
    }
    
    //MARK: - Handler
    func addCategory() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default, handler: {(action) in
            if textField.hasText {
                var newCategory: CategoryData
                let name = textField.text!
                let colour = UIColor.randomFlat().hexValue()
                newCategory.name = name
                newCategory.colour = colour
                newCategory.categoryId = 3
                
                try? CategoryDataHelper.insert(item: newCategory)
                self.loadCategories()
            }
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(actionCancel)
        alert.addTextField(configurationHandler: {(feild) in
            textField = feild
            textField.placeholder = "Enter new Category"
            
        })
        present(alert, animated: true)
    }
    
//    func saveCategories(with category: Category) {
//            do {
//                try realm.write{
//                    realm.add(category)
//                }
//            } catch {
//                print("Error to save Category with \(error)")
//            }
//        initView()
//
////            tableView.reloadData()
//        }
        
        func loadCategories() {
            if let categoryDatas = try? CategoryDataHelper.queryAll() {
                for categoryData in categoryDatas {
                    categories.append(CategoryBridge.toCategory(categoryData: categoryData))
                }
            }
            self.initView()
            
        }
    // Protocol
    func handlerAddTask(for message: MessageController) {
        addBtnPressed()
    }
    

    

}
