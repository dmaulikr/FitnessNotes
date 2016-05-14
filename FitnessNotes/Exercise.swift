//
//  Exercise.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 4/19/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import Foundation
import CoreData
import CoreDataHelpers

final class Exercise: ManagedObject {
    @NSManaged var name: String
    @NSManaged var note: String?
    @NSManaged var type: String
    @NSManaged var bodyPart: BodyPart
    
    static func insertExerciseIntoContext(moc: NSManagedObjectContext, name: String, note: String? = nil, bodyPart: BodyPart) ->Exercise {
        let exerciseEntity: Exercise = moc.insertObject()
        exerciseEntity.name = name
        exerciseEntity.note = note
        exerciseEntity.bodyPart = bodyPart
        
        return exerciseEntity
    }
}


extension Exercise: KeyCodable {
    enum Keys: String {
        case name = "name"
        case note = "note"
        case bodyPart = "bodyPart"
    }
}


extension Exercise: DefaultManagedObjectType {
    static var entityName: String {
        return "Exercise"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: false)]
    }
}


