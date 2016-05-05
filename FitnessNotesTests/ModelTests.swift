//
//  ModelTests.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/3/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import XCTest
import CoreData
import SwiftyJSON

@testable import FitnessNotes

class ModelTests: XCTestCase {
    
    var moc: NSManagedObjectContext!
    var parser: JsonToModelParser!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        moc = CoreDataStack().managedObjectContext
        parser = JsonToModelParser()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReadJsonFileFromBundle_ShouldNotBeNil() {
        let json = parser.parseJsonFileToJSONObject()
        print(json)
        XCTAssertNotNil(json)
    }
    
    func testJsonParser_ShouldSaveJsonToCoreData() {
        let json = parser.parseJsonFileToJSONObject()
        parser.saveJsonToPreloadExercise(withContext: moc, exeJson: json!)
    }

    func testDocumentUrl() {
        let url = NSURL.documentUrl
        print(url)
        XCTAssertNotNil(url)
    }
    
}
