//
//  CustomLogFormatter.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/3/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit
import CocoaLumberjack

class CustomLogFormatter: NSObject ,DDLogFormatter {
    @objc func formatLogMessage(logMessage: DDLogMessage!) -> String! {
        let fileName = logMessage.fileName
        let functionName = logMessage.function
        let lineNumber = logMessage.line
        let timestamp = logMessage.timestamp
        let message = logMessage.message
        
        return "(\(timestamp))\(fileName)| \(functionName)@\(lineNumber)| \(message)"
    }
}
