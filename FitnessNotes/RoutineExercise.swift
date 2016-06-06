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
    @NSManaged var note: String?
    @NSManaged var exercise: Exercise
    @NSManaged var routine: Routine?
    @NSManaged var sets: NSSet
    
    static func insertIntoContext(moc: NSManagedObjectContext, exercise: Exercise, routine: Routine? = nil, note: String? = nil, sets: NSSet? = nil ) ->RoutineExercise {
        let entity: RoutineExercise = moc.insertObject()
        entity.exercise = exercise
        entity.routine = routine
        
        entity.note = note
        if let s = sets {
            entity.sets = s
        } else {
            RoutineExercise.defaultSets(moc, inExercise: entity)
        }
        
        return entity
    }
}


extension RoutineExercise: KeyCodable {
    enum Keys: String {
        case exercise = "exercise"
        case note = "note"
        case routine = "routine"
        case sets = "sets"
    }
}


extension RoutineExercise: DefaultManagedObjectType {
    static var entityName: String {
        return "RoutineExercise"
    }
    
    private static func defaultSets(moc: NSManagedObjectContext, inExercise exercise: RoutineExercise) ->Set<RoutineExerciseSet> {
        
        var exerciseSet = Set<RoutineExerciseSet>()
        
        for i in 1..<5 {
            let set = RoutineExerciseSet.insertIntoContext(moc, set: i, exercise: exercise)
            exerciseSet.insert(set)
        }
        
        return exerciseSet
    }
}
















