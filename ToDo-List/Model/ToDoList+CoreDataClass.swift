//
//  ToDoList+CoreDataClass.swift
//  ToDo-List
//
//  Created by 陳列 on 2022/3/30.
//
//

import Foundation
import CoreData


public class ToDoList: NSManagedObject {

}


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var complete: Bool
    @NSManaged public var date: Date?

}

extension ToDoList : Identifiable {

}

