//
//  WorkoutExercise.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/14/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import Foundation
import CoreData
import CoreDataHelpers
import CocoaLumberjack

class WorkoutExercise: ManagedObject {
    @NSManaged var note: String?
    @NSManaged var exercise: Exercise?
    @NSManaged var sets: NSSet?
    @NSManaged var workoutLog: WorkoutLog?
    
    static func insertIntoContext(moc: NSManagedObjectContext, note: String? = nil, exercise: RoutineExercise, sets: NSSet? = nil, workoutLog: WorkoutLog) ->WorkoutExercise {
        let entity: WorkoutExercise = moc.insertObject()
        entity.note = note
        entity.exercise = exercise.exercise
        entity.sets = sets
        entity.workoutLog = workoutLog
        
        return entity
    }
    
//    static func insertIntoContext(moc: NSManagedObjectContext, routineExercise: RoutineExercise) ->WorkoutExercise {
//        let entity: WorkoutExercise = moc.insertObject()
//        entity.exercise = routineExercise.exercise
//    }
}


extension WorkoutExercise: KeyCodable {
    enum Keys:String {
        case note = "note"
        case exercise = "exercise"
        case sets = "sets"
        case workoutLog = "workoutLog"
    }
}

extension WorkoutExercise: DefaultManagedObjectType {
    static var entityName: String {
        return "WorkoutExercise"
    }
}