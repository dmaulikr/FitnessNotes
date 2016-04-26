//
//  Utilities.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 4/20/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import Foundation

extension NSURL {
    static var documentUrl: NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    }
    
    static var LibraryUrl: NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask).first
    }
    
    static var applicationSupportDirectory: NSURL {
        let fileManager = NSFileManager.defaultManager()
        
        let appSupportDir = try! fileManager.URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        guard let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier else {
            return appSupportDir
        }
        
        let filePathUrl = appSupportDir.URLByAppendingPathComponent(bundleIdentifier)
        
        if !fileManager.fileExistsAtPath(filePathUrl.absoluteString) {
            do {
                try fileManager.createDirectoryAtURL(filePathUrl, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Create Library/Application Support/bundle identifier directory failed with error \(error)")
                return appSupportDir
            }
        }
        
        return filePathUrl
    }
    
    static func fileUrl(withName name: String, atRootUrl rootUrl: NSURL) ->NSURL {
        let fileUrl = rootUrl.URLByAppendingPathComponent(name)
        return fileUrl
    }
}