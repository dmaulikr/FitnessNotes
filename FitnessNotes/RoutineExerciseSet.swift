//
//  RoutineExerciseSets.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/12/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import Foundation
import CoreData
import CoreDataHelpers

final class RoutineExerciseSet: ManagedObject {
    @NSManaged var set: NSNumber
    @NSManaged var weight: NSNumber?
    @NSManaged var reps: NSNumber
    @NSManaged var exercise: RoutineExercise
    
    static func insertIntoContext(moc: NSManagedObjectContext, set: Int, weight: Double? = nil, reps: Int = 10, exercise: RoutineExercise) ->RoutineExerciseSet{
        let entity: RoutineExerciseSet = moc.insertObject()
        
        entity.set = NSNumber(integer: set)
        if weight == nil {
            entity.weight = nil
        } else {
            entity.weight = NSNumber(double: weight!)
        }
        entity.reps = NSNumber(integer: reps)
        entity.exercise = exercise
        
        return entity
    }
}

extension RoutineExerciseSet: KeyCodable {
    enum Keys: String {
        case set = "set"
        case weight = "weight"
        case reps = "reps"
        case exercise = "exercise"
    }
}

extension RoutineExerciseSet: DefaultManagedObjectType {
    static var entityName: String {
        return "RoutineExerciseSet"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "set", ascending: true)]
    }
}


