//
//  FitnessNotesTests.swift
//  FitnessNotesTests
//
//  Created by Yang, Yusheng on 4/19/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import XCTest
@testable import FitnessNotes

class FitnessNotesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        guard let filePath = NSBundle.mainBundle().pathForResource("ExerciseLog", ofType: "json") else { print("FilePath cannot find")
        return }
        //let jsonData = NSData(contentsOfFile: filePath)
        if let jsonString = try? String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding) {
            print(jsonString)
        } else {
            print("Cannot read")
        }
        
    }
    
    func testLocalJsonFileRead() {
        let myArray = [1,2,3,4,5,6,7,8]
        let supportDir = NSURL.applicationSupportDirectory
        let array = myArray as NSArray
        
        let filePath = supportDir.URLByAppendingPathComponent("tmpFile.txt")
        print(filePath.absoluteString)
        array.writeToURL(filePath, atomically: true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
