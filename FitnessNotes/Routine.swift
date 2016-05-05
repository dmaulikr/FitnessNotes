//
//  Routine.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/3/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import Foundation
import CoreData
import CoreDataHelpers

final class Routine: ManagedObject{
    @NSManaged var name: String
    @NSManaged var createDate: NSDate
    @NSManaged var note: String?
    @NSManaged var exercises: NSSet?
    
    static func insertRoutineIntoContext(moc: NSManagedObjectContext, name: String, note: String? = nil, exercises: NSSet? = nil) ->Routine {
        let entity: Routine = moc.insertObject()
        entity.name = name
        entity.createDate = NSDate()
        entity.note = note
        entity.exercises = exercises
        
        return entity
    }
}

extension Routine: KeyCodable {
    enum Keys: String {
        case name = "name"
        case note = "note"
        case createDate = "createDate"
        case exercises = "exercises"
    }
}

extension Routine: DefaultManagedObjectType {
    static var entityName: String {
        return "Routine"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: false)]
    }
}
