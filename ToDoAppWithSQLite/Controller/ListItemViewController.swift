//
//  ListItemViewController.swift
//  ToDoAppWithSQLite
//
//  Created by Trần Huy on 8/18/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework



class ListItemsViewController: UIViewController {
     //MARK: - Properties
//        
//    
    var listItems: Array<Item>?
    var selectedCategory: Category? {
        didSet {
            listItems = try? ItemDataHelper.queryWithSelectedCategory(with: selectedCategory!)
            listItems?.sort(by:{
                if ($0.dateDue != nil) && ($1.dateDue != nil) {
                    $0.dateDue! < $1.dateDue!
                }
                return true
            })
//             listItems = selectedCategory?.items.sorted(byKeyPath: "dateDue", ascending: true)
        }
    }
        
        //MARK: Init
        override func viewDidLoad() {
            super.viewDidLoad()
            initView()
            

            // Do any additional setup after loading the view.
        }
        override func viewWillAppear(_ animated: Bool) {
            configNavigationView()
        }
        
        //MARK: - Handler
        func initView() {
            view.backgroundColor = .white
            
            if listItems!.isEmpty {
                let message = MessageController(text: "Tap the button to create your first task", actionTitle: "Create Task", actionHandler: {[weak self] in
                    self?.addTaskItem()
                })
                
                message.view.frame = self.view.bounds
                
//                message.delegate = self
                message.willMove(toParent: self)
                view.addSubview(message.view)
                self.addChild(message)
                message.didMove(toParent: self)
            } else {
                let todoVC = TodoView()
                todoVC.view.frame = self.view.bounds
                todoVC.willMove(toParent: self)
                view.addSubview(todoVC.view)
                todoVC.selectedCategory = selectedCategory
                self.addChild(todoVC)
                todoVC.didMove(toParent: self)
                
            }
        }
        
        func configNavigationView() {
//               navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
//               navigationItem.rightBarButtonItem?.tintColor = UIColor.white
//               navigationItem.title = "TodoApp"
//
//               navigationController?.navigationBar.barTintColor = UIColor.systemBlue
            navigationItem.title = selectedCategory?.name
            
            
            if let colourHex = selectedCategory?.colour {
                
                navigationController?.navigationBar.barTintColor = UIColor(hexString: colourHex)
                
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString: colourHex)!, returnFlat: true)]
                navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: colourHex)!, returnFlat: true)
                navigationItem.rightBarButtonItem?.tintColor = ContrastColorOf(UIColor(hexString: colourHex)!, returnFlat: true)

                
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
            navigationController?.navigationBar.topItem?.title = "Back To Home"
        }
        
        //MARK: - Selector
        
        @objc func addBtnPressed() {
            addTaskItem()
        }
        
        //MARK: - Handler
        func addTaskItem() {
            var textField = UITextField()
            var due: Date? = nil
            let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: {(feild) in
                textField = feild
                textField.placeholder = "Enter your task"
            })
            alert.addDatePicker { (tf, dp) in
                tf.placeholder = "Due"
                dp.minimumDate = Date()
                dp.datePickerMode = .date
            }
            let action = UIAlertAction(title: "Add", style: .default, handler: {(action) in
                if textField.hasText {
                    if let curCategory = self.selectedCategory {
                        do {
                            var newItemData: ItemData
                            newItemData.title = textField.text
                            newItemData.dateCreated = Date()
                            if alert.textFields?[1].text?.isEmpty == false {
                                due = alert.datePickers?[1]?.date
                            }
                            newItemData.dateDue = due
                            
                            newItemData.categoryId = curCategory.categoryTd
                            newItemData.itemId = 1
                            newItemData.done = false
                            newItemData.dateCompleted = nil
                            
                            try? ItemDataHelper.insert(item: newItemData)
                        } catch {
                            print("Error")
                        }
                        self.loadCategories()
                        self.initView()
                    }
                
                }
            })
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(actionCancel)
            
            present(alert, animated: true)
        }
        
        func saveCategories(with category: Category) {
//                do {
//                    try realm.write{
//                        realm.add(category)
//                    }
//                } catch {
//                    print("Error to save Category with \(error)")
//                }
            initView()
            
    //            tableView.reloadData()
            }
            
            func loadCategories() {
                listItems = try? ItemDataHelper.queryWithSelectedCategory(with: selectedCategory!)
//                listItems?.sort(by: {$1.dateDue! < $0.dateDue!})
                
                
            }
        // Protocol
        func handlerAddTask(for message: MessageController) {
            addBtnPressed()
        }
        
}
