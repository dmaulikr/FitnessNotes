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
    @NSManaged var note: String?
    @NSManaged var routine: Routine?
    @NSManaged var sets: NSSet
    
    static func insertRoutineExerciseIntoContext(moc: NSManagedObjectContext, name: String, routine: Routine? = nil, note: String? = nil, sets: NSSet? = nil ) ->RoutineExercise {
        let entity: RoutineExercise = moc.insertObject()
        entity.name = name
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
        case name = "name"
        case note = "note"
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
    
    private static func defaultSets(moc: NSManagedObjectContext, inExercise exercise: RoutineExercise) ->Set<RoutineExerciseSet> {
        
        var exerciseSet = Set<RoutineExerciseSet>()
        
        for i in 1..<5 {
            let set = RoutineExerciseSet.insertIntoContext(moc, set: NSNumber(integer: i), exercise: exercise)
            exerciseSet.insert(set)
        }
        
        return exerciseSet
    }
}
















