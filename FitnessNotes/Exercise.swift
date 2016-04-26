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
    @NSManaged var note: String
}


extension Exercise: KeyCodable {
    enum Keys: String {
        case name = "name"
        case note = "note"
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


