//
//  ToDoListItem.swift
//  To-Do
//
//  Created by Davran Arifzhanov on 10.11.2020.
//

import Foundation
import RealmSwift

class ToDoListItem: Object{
    @objc dynamic var todoID = UUID().uuidString //guaranteed unique
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var done = false
    
    override class func primaryKey() -> String? {
            return "todoID"
    }
    
}
