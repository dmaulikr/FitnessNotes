//
//  JsonToModelParser.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/3/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
import CocoaLumberjack

class JsonToModelParser {
    
    func parseJsonFileToJSONObject() ->JSON?{
        let path = NSBundle.mainBundle().pathForResource("ExerciseLog", ofType: "json")
        guard let filePath = path else {
            DDLogError("Cannot find \"ExerciseLog.jon\" in the bundle")
            return nil
        }
        let data = NSData(contentsOfFile: filePath)
        guard let jsonData = data else { return nil }
        
        return JSON(data: jsonData)
    }
    
    
    func saveJsonToPreloadExercise(withContext moc: NSManagedObjectContext, exeJson: JSON) {
        for (bodypart, exerciseJson) in exeJson.dictionaryValue {
            let entity = BodyPart.insertBodyPartIntoContext(moc, name: bodypart)
            let exerciseEntities = exerciseJson.arrayValue.map({ (jsonItem) -> Exercise in
                Exercise.insertExerciseIntoContext(moc, name: jsonItem.stringValue, bodyPart: entity)
            })
            
            entity.exercise = NSSet(array: exerciseEntities)
        }
        
        moc.performSaveOrRollback()
    }
}