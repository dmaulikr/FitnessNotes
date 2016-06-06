//
//  WorkoutExerciseSet.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/14/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import Foundation
import CoreData
import CoreDataHelpers
import CocoaLumberjack


class WorkoutExerciseSet: ManagedObject {
    @NSManaged var reps: NSNumber //Int
    @NSManaged var set: NSNumber //Int
    @NSManaged var weight: NSNumber? //double
    @NSManaged var exercise: WorkoutExercise
    @NSManaged var finishFlag: NSNumber
    
    
    static func insertIntoContext(moc: NSManagedObjectContext, reps: Int, set: Int, weight: Double? = nil, finishFlag: Bool = false ,exercise: WorkoutExercise) ->WorkoutExerciseSet{
        let entity: WorkoutExerciseSet = moc.insertObject()
        entity.reps = NSNumber(integer: reps)
        entity.set = NSNumber(integer: set)
        if let w = weight {
            entity.weight = NSNumber(double: w)
        } else {
            entity.weight = nil
        }
        
        entity.exercise = exercise
        entity.finishFlag = NSNumber(bool: finishFlag)
        
        return entity
    }
}


extension WorkoutExerciseSet: KeyCodable {
    enum Keys: String {
        case reps = "reps"
        case set = "set"
        case weight = "weight"
        case exercise = "exercise"
        case finishFlag = "finishFlag"
    }
}

extension WorkoutExerciseSet: DefaultManagedObjectType {
    static var entityName: String {
        return "WorkoutExerciseSet"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "set", ascending: true)]
    }
}