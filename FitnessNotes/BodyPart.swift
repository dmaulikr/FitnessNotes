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
}

extension BodyPart: KeyCodable {
    enum Keys: String {
        case name = "name"
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