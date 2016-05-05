//
//  RoutineExercise.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/3/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import Foundation
import CoreData
import CoreDataHelpers


final class RoutineExercise: ManagedObject {
    @NSManaged var name: String
    @NSManaged var reps: NSNumber
    @NSManaged var set: NSNumber
    @NSManaged var weight: NSNumber?
    @NSManaged var routine: Routine?
    
    static func insertRoutineExerciseIntoContext(moc: NSManagedObjectContext, name: String, reps: Int = 10, set: Int = 4, weight: Double? = nil, routine: Routine? = nil) ->RoutineExercise {
        let entity: RoutineExercise = moc.insertObject()
        entity.name = name
        entity.reps = NSNumber(integer: reps)
        entity.set = NSNumber(integer: set)
        entity.routine = routine
        if let w = weight {
             entity.weight = NSNumber(double: w)
        } else {
             entity.weight = nil
        }
       
        
        return entity
    }
}


extension RoutineExercise: KeyCodable {
    enum Keys: String {
        case name = "name"
        case reps = "reps"
        case set = "set"
        case weight = "weight"
        case routine = "routine"
    }
}


extension RoutineExercise: DefaultManagedObjectType {
    static var entityName: String {
        return "RoutineExercise"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: false)]
    }
}
















