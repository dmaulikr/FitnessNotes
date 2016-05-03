//
//  ViewController.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 4/19/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DDLogVerbose("Verbose");
        DDLogDebug("Debug");
        DDLogInfo("Info");
        DDLogWarn("Warn");
        DDLogError("Error");
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

