//
//  AppDelegate.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 4/19/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjack


//#if DEVELOPMENT
//let SERVER_URL = "http://dev.server.com/api/"
//let API_TOKEN = "DI2023409jf90ew"
//#else
//let SERVER_URL = "http://prod.server.com/api/"
//let API_TOKEN = "71a629j0f090232"
//#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var coredataStack: CoreDataStack?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //CoreDataStack
        coredataStack = CoreDataStack()
        
        //configure the log system
        let logFormatter = CustomLogFormatter()
        DDASLLogger.sharedInstance().logFormatter = logFormatter
        DDTTYLogger.sharedInstance().logFormatter = logFormatter
        
        DDLog.addLogger(DDASLLogger.sharedInstance(), withLevel: .Info)
        DDLog.addLogger(DDTTYLogger.sharedInstance(), withLevel: .Debug)
        
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.addLogger(fileLogger, withLevel: .Info)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coredataStack?.saveContext()
    }

}

//MARK: - App First Time Launch
extension AppDelegate {
    func preloadData() {
        let jsonToModel = JsonToModelParser()
        let tmpJson = jsonToModel.parseJsonFileToJSONObject()
        guard let jsonFile = tmpJson else {
            DDLogError("Cannot read Preload Json File, impossible!!!")
            fatalError()
        }
        
        jsonToModel.saveJsonToPreloadExercise(withContext: coredataStack!.mainContext, exeJson: jsonFile)
    }
}









