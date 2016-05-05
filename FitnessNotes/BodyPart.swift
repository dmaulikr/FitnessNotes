//
//  BodyPart.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 4/19/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import Foundation
import CoreData
import CoreDataHelpers

final class BodyPart: ManagedObject {
    @NSManaged var name: String
    @NSManaged var exercise: NSSet?
    
    static func insertBodyPartIntoContext(moc: NSManagedObjectContext, name: String, exercise: NSSet? = nil) ->BodyPart {
        let bodyPartEntity: BodyPart = moc.insertObject()
        bodyPartEntity.name = name
        bodyPartEntity.exercise = exercise
        
        return bodyPartEntity
    }
}

extension BodyPart: KeyCodable {
    enum Keys: String {
        case name = "name"
        case exercise = "exercise"
    }
}


extension BodyPart: DefaultManagedObjectType {
    static var entityName: String {
        return "BodyPart"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: false)]
    }
    
    
    
}