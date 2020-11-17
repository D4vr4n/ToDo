//
//  ViewController.swift
//  To-Do
//
//  Created by Davran Arifzhanov on 10.11.2020.
//

import UIKit
import RealmSwift
import Realm


class ViewController: UITableViewController {
    
    
    var realm: Realm!
    var toDoList: Results<ToDoListItem>{
        get{
            return realm.objects(ToDoListItem.self)
        }
    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    // MARK -- Table Show
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = toDoList[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.desc
        
        cell.accessoryType = item.done == true ? .checkmark: .none
        
        return cell
    }
    
    //MARK -- Selectedrow for put checkmark(Mark work as done)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = toDoList[indexPath.row]
        try! self.realm.write({
            item.done = !item.done
        })
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK -- Edit Actions for ech row on swipe(edit, delete)
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //MARK -- Edit the added item
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
                
            let alertVC1 = UIAlertController(title: "Update To Do", message: "What do you want update?", preferredStyle: .alert)
            
            alertVC1.addTextField { (textField : UITextField!) -> Void in
                textField.text = self.toDoList[indexPath.row].title
            }
            alertVC1.addTextField { (textField : UITextField!) -> Void in
                textField.text = self.toDoList[indexPath.row].desc
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alertVC1.addAction(cancelAction)
            //MARK -- SaveAction button handling to update selected item
            let saveAction = UIAlertAction(title: "Save", style: .default) { (UIAlertAction) in
                let titleTextField1 = alertVC1.textFields![0] as UITextField
                let descTextField1 = alertVC1.textFields![1] as UITextField
                
                let updatedToDoListItem = ToDoListItem()
                updatedToDoListItem.title = titleTextField1.text!
                updatedToDoListItem.desc = descTextField1.text!
                updatedToDoListItem.todoID = self.toDoList[indexPath.row].todoID
                updatedToDoListItem.done = self.toDoList[indexPath.row].done
                //MARK -- Updating realm
                try! self.realm.write({
                    self.realm.add(updatedToDoListItem, update: .modified)
                    //MARK -- Updating tableView
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                })
            }
            alertVC1.addAction(saveAction)
            
            self.present(alertVC1, animated: true, completion: nil)
            
            
            }
            editAction.backgroundColor = .darkGray
        //MARK -- Delete the added item
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            let item = self.toDoList[indexPath.row]
            //MARK -- Deleting item from realm
            try! self.realm.write({
                self.realm.delete(item)
            })
            //MARK -- deleterows from tableView
            tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
            deleteAction.backgroundColor = .red

            return [editAction,deleteAction]
    }
    
    
    //MARK -- Handling addButtonTap
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        //MARK -- Creating alertVC with 2 textFields and two buttons
        let alertVC = UIAlertController(title: "New To Do", message: "What do you want to do?", preferredStyle: .alert)
        alertVC.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Title"
        }
        alertVC.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Description"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertVC.addAction(cancelAction)
        
        //MARK -- Handling AddButtonTap
        let addAction = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) -> Void in
            
            let titleTextField = alertVC.textFields![0] as UITextField
            let descTextField = alertVC.textFields![1] as UITextField
            //MARK -- Creating new Object
            let newToDoListItem = ToDoListItem()
            
            newToDoListItem.title = titleTextField.text!
            newToDoListItem.desc = descTextField.text!
            newToDoListItem.done = false
            //MARK -- Adding new created object to realm
            try! self.realm.write({
                self.realm.add(newToDoListItem)
                //MARK -- Updating tableView
                self.tableView.insertRows(at: [IndexPath.init(row: self.toDoList.count-1, section: 0)], with: .automatic)
            })
            
        }
        //MARK -- Presenting alertVC when addButtonTapped
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
    }
        
        
        
    
}

