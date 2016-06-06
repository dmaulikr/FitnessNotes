//
//  WorkoutLog.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/14/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import Foundation
import CoreData
import CoreDataHelpers

class WorkoutLog: ManagedObject {
    @NSManaged var dateAndTime: NSDate?
    @NSManaged var duration: NSNumber? //Int
    @NSManaged var note: String?
    @NSManaged var exercise: NSSet?
    @NSManaged var routine: Routine?
    
    static func insetIntoContext(moc: NSManagedObjectContext, dateTime: NSDate, duration: Int, note: String? = nil, exercise: NSSet? = nil, routine: Routine) ->WorkoutLog {
        let entity: WorkoutLog = moc.insertObject()
        entity.dateAndTime = dateTime
        entity.duration = NSNumber(integer: duration)
        entity.note = note
        entity.exercise = exercise
        entity.routine = routine
        
        return entity
    }
}


extension WorkoutLog: KeyCodable {
    enum Keys: String {
        case dateAndTime = "dateAndTime"
        case duration = "duration"
        case note = "note"
        case exercise = "exercise"
        case routine = "routine"
    }
}


extension WorkoutLog: DefaultManagedObjectType {
    static var entityName: String {
        return "WorkoutLog"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "dateAndTime", ascending: false)]
    }
}
